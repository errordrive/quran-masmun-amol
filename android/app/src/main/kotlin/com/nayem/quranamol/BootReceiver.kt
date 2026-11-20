package com.nayem.quranamol

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

// v3.2: re-schedules the azan notifications after a phone restart (and
// when the clock or timezone changes) WITHOUT opening any UI.
//
// AlarmManager alarms are wiped on reboot, so without this the azan
// stayed silent until the user opened the app once. The receiver spins
// up a background FlutterEngine, registers the plugins (SharedPreferences
// + flutter_local_notifications) and runs the `bootReschedule` Dart
// entrypoint in main.dart, which re-schedules today + tomorrow from the
// stored prefs. The Dart side calls back on the 'boot_reschedule'
// channel when done, so the engine is destroyed and the broadcast
// released; a 9s safety net covers a Dart side that never calls back.
// No new permissions: RECEIVE_BOOT_COMPLETED is already declared.
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != Intent.ACTION_TIME_CHANGED &&
            action != Intent.ACTION_TIMEZONE_CHANGED
        ) return

        val pending = goAsync()
        var finished = false
        fun finishOnce() {
            if (!finished) {
                finished = true
                try {
                    pending.finish()
                } catch (_: Exception) {
                }
            }
        }

        try {
            val engine = FlutterEngine(context)
            GeneratedPluginRegistrant.registerWith(engine)
            MethodChannel(
                engine.dartExecutor.binaryMessenger,
                "boot_reschedule"
            ).setMethodCallHandler { call, _ ->
                if (call.method == "done") {
                    try {
                        engine.destroy()
                    } catch (_: Exception) {
                    }
                    finishOnce()
                }
            }
            val entrypoint = DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "bootReschedule"
            )
            engine.dartExecutor.executeDartEntrypoint(entrypoint)
            // Safety net: never hold the broadcast longer than 9s.
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    engine.destroy()
                } catch (_: Exception) {
                }
                finishOnce()
            }, 9000)
        } catch (_: Exception) {
            finishOnce()
        }
    }
}
