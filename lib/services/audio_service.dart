// Audio tilawat (v2.0) — STREAMING ONLY, nothing is bundled in the APK.
// Reciter: Mishary Rashid Alafasy (default and only reciter in v2).
// Source: per-ayah MP3s from EveryAyah:
//   https://everyayah.com/data/Alafasy_64kbps/{surah:03}{ayah:03}.mp3
// (v2.0.1: the Islamic Network CDN per-ayah path returns HTTP 403, so it
// was replaced — the file names are identical, only the host changed.)
// A full surah is streamed ayah-by-ayah and auto-advances; the reader
// highlights the ayah currently playing. A surah can also be downloaded
// (only that surah, never the whole Quran) into the app documents
// directory, after which it plays offline from local files.
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

const String _cdnBase = 'https://everyayah.com/data/Alafasy_64kbps';

String _ayahFileName(int surah, int ayah) =>
    '${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';

String ayahAudioUrl(int surah, int ayah) =>
    '$_cdnBase/${_ayahFileName(surah, ayah)}';

class AudioService extends ChangeNotifier {
  static final AudioService instance = AudioService._();
  AudioService._() {
    _player.currentIndexStream.listen((index) {
      if (_startAyah != null && index != null) {
        playingAyah = _startAyah! + index;
        notifyListeners();
      }
    });
    _player.playerStateStream.listen((s) {
      final wasPlaying = isPlaying;
      isPlaying = s.playing;
      if (s.processingState == ProcessingState.completed) {
        stop();
        return;
      }
      if (wasPlaying != isPlaying) notifyListeners();
    });
    _loadDownloaded();
  }

  final AudioPlayer _player = AudioPlayer();

  int? playingSurah;
  int? playingAyah;
  bool isPlaying = false;
  bool isLoading = false;
  String? error;
  // The surah [error] belongs to — so the reader bar shows it on the
  // right surah (a download error has no playingSurah).
  int? errorSurah;

  int? _startAyah;
  bool _starting = false;

  /// True when the device can reach the audio host. Used ONLY on the
  /// error path, so a playback/download failure blames the right cause:
  /// no network vs. the audio server being unavailable. Never blame
  /// the internet when the server is the problem.
  Future<bool> _hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('everyayah.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ---- Downloads (per surah, local files) ----
  final Set<int> downloadedSurahs = {};
  int? downloadingSurah;
  double downloadProgress = 0;

  Future<Directory> _audioDir() async {
    final docs = await getApplicationDocumentsDirectory();
    return Directory('${docs.path}/audio');
  }

  Future<File> _localFile(int surah, int ayah) async {
    final dir = await _audioDir();
    return File(
        '${dir.path}/surah_${surah.toString().padLeft(3, '0')}/${_ayahFileName(surah, ayah)}');
  }

  Future<void> _loadDownloaded() async {
    try {
      final dir = await _audioDir();
      if (!await dir.exists()) return;
      await for (final e in dir.list()) {
        if (e is Directory) {
          final name = e.path.split('/').last; // surah_001
          final n = int.tryParse(name.replaceFirst('surah_', ''));
          if (n != null) downloadedSurahs.add(n);
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  bool isDownloaded(int surah) => downloadedSurahs.contains(surah);

  /// Downloads one surah's ayah MP3s. Progress 0..1 via [onProgress].
  /// Returns false on failure (e.g. no internet) — the error is kept in
  /// [error] and any partial files are removed.
  Future<bool> downloadSurah(
    Surah surah, {
    void Function(double progress)? onProgress,
  }) async {
    if (downloadingSurah != null) return false;
    downloadingSurah = surah.number;
    downloadProgress = 0;
    error = null;
    errorSurah = null;
    notifyListeners();
    final client = HttpClient();
    final files = <File>[];
    try {
      for (final ayah in surah.ayahs) {
        final file = await _localFile(surah.number, ayah.numberInSurah);
        if (await file.exists()) {
          files.add(file);
          downloadProgress = files.length / surah.ayahs.length;
          onProgress?.call(downloadProgress);
          notifyListeners();
          continue;
        }
        await file.parent.create(recursive: true);
        final req = await client
            .getUrl(Uri.parse(ayahAudioUrl(surah.number, ayah.numberInSurah)));
        final resp = await req.close();
        if (resp.statusCode != 200) {
          throw HttpException('HTTP ${resp.statusCode}');
        }
        final sink = file.openWrite();
        var received = 0;
        final total = resp.contentLength; // may be -1
        await for (final chunk in resp) {
          received += chunk.length;
          sink.add(chunk);
          if (total > 0) {
            downloadProgress =
                (files.length + received / total) / surah.ayahs.length;
            onProgress?.call(downloadProgress);
            notifyListeners();
          }
        }
        await sink.close();
        files.add(file);
        downloadProgress = files.length / surah.ayahs.length;
        onProgress?.call(downloadProgress);
        notifyListeners();
      }
      downloadedSurahs.add(surah.number);
      return true;
    } catch (e) {
      // Blame the right cause: a socket failure means no network, an
      // HTTP error means the server refused/doesn't have the audio.
      if (e is SocketException) {
        error = 'ইন্টারনেট সংযোগ নেই — সংযোগ দেখুন।';
      } else if (e is HttpException) {
        error = 'অডিও সার্ভার থেকে পাওয়া যায়নি — পরে আবার চেষ্টা করুন।';
      } else {
        error = 'ডাউনলোড হয়নি — পরে আবার চেষ্টা করুন।';
      }
      errorSurah = surah.number;
      // Remove partial files so a half-download never plays.
      for (final f in files) {
        try {
          if (await f.exists()) await f.delete();
        } catch (_) {}
      }
      downloadedSurahs.remove(surah.number);
      return false;
    } finally {
      client.close();
      downloadingSurah = null;
      downloadProgress = 0;
      notifyListeners();
    }
  }

  Future<void> deleteSurah(int surahNumber) async {
    try {
      final dir = await _audioDir();
      final sub = Directory(
          '${dir.path}/surah_${surahNumber.toString().padLeft(3, '0')}');
      if (await sub.exists()) await sub.delete(recursive: true);
    } catch (_) {}
    downloadedSurahs.remove(surahNumber);
    if (playingSurah == surahNumber) stop();
    notifyListeners();
  }

  // ---- Playback ----

  /// Plays [surah] from [startAyah] (1-based), ayah by ayah, auto-advance.
  /// Plays from local files when the surah was downloaded, otherwise
  /// streams from the CDN. On failure [error] is set to the right cause:
  /// no internet, audio unavailable on the server, or a playback error
  /// (downloaded files) — never a wrong "check internet" blame.
  Future<void> playSurah(Surah surah, {int startAyah = 1}) async {
    if (_starting) return;
    _starting = true;
    isLoading = true;
    error = null;
    errorSurah = null;
    notifyListeners();
    var fromLocal = false;
    try {
      fromLocal = isDownloaded(surah.number);
      final sources = <AudioSource>[];
      for (var i = startAyah - 1; i < surah.ayahs.length; i++) {
        final ayah = surah.ayahs[i];
        if (fromLocal) {
          final file = await _localFile(surah.number, ayah.numberInSurah);
          if (await file.exists()) {
            sources.add(AudioSource.uri(Uri.file(file.path)));
            continue;
          }
          // A downloaded surah missing a file: fall back to streaming it.
        }
        sources.add(AudioSource.uri(
            Uri.parse(ayahAudioUrl(surah.number, ayah.numberInSurah))));
      }
      _startAyah = startAyah;
      playingSurah = surah.number;
      playingAyah = startAyah;
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
      );
      await _player.play();
    } catch (_) {
      if (fromLocal) {
        // Local files — the network is not involved at all.
        error = 'অডিও চালানো যায়নি — পরে আবার চেষ্টা করুন।';
      } else if (await _hasNetwork()) {
        error = 'এই আয়াতের অডিও পাওয়া যায়নি — পরে আবার চেষ্টা করুন।';
      } else {
        error = 'ইন্টারনেট সংযোগ নেই — সংযোগ দেখুন।';
      }
      errorSurah = surah.number;
      playingSurah = null;
      playingAyah = null;
      _startAyah = null;
    } finally {
      isLoading = false;
      _starting = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  Future<void> resume() async {
    try {
      await _player.play();
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    playingSurah = null;
    playingAyah = null;
    _startAyah = null;
    isPlaying = false;
    notifyListeners();
  }
}
