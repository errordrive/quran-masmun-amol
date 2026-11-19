// Bundled city list for the location picker (lat/lon + UTC offset).
// Offsets are standard time; daylight saving is not applied.
import '../models/models.dart';

const List<City> cities = [
  // Bangladesh
  City(name: 'Dhaka', country: 'Bangladesh', lat: 23.8103, lon: 90.4125, tzOffset: 6),
  City(name: 'Chattogram', country: 'Bangladesh', lat: 22.3569, lon: 91.7832, tzOffset: 6),
  City(name: 'Khulna', country: 'Bangladesh', lat: 22.8456, lon: 89.5403, tzOffset: 6),
  City(name: 'Rajshahi', country: 'Bangladesh', lat: 24.3745, lon: 88.6042, tzOffset: 6),
  City(name: 'Sylhet', country: 'Bangladesh', lat: 24.8949, lon: 91.8687, tzOffset: 6),
  City(name: 'Barishal', country: 'Bangladesh', lat: 22.7010, lon: 90.3535, tzOffset: 6),
  City(name: 'Rangpur', country: 'Bangladesh', lat: 25.7439, lon: 89.2752, tzOffset: 6),
  City(name: 'Mymensingh', country: 'Bangladesh', lat: 24.7471, lon: 90.4203, tzOffset: 6),
  City(name: 'Cumilla', country: 'Bangladesh', lat: 23.4683, lon: 91.1788, tzOffset: 6),
  City(name: "Cox's Bazar", country: 'Bangladesh', lat: 21.4272, lon: 92.0058, tzOffset: 6),
  City(name: 'Narayanganj', country: 'Bangladesh', lat: 23.6239, lon: 90.5000, tzOffset: 6),
  City(name: 'Gazipur', country: 'Bangladesh', lat: 24.0023, lon: 90.4264, tzOffset: 6),
  // Middle East
  City(name: 'Makkah', country: 'Saudi Arabia', lat: 21.3891, lon: 39.8579, tzOffset: 3),
  City(name: 'Madinah', country: 'Saudi Arabia', lat: 24.5247, lon: 39.5692, tzOffset: 3),
  City(name: 'Jeddah', country: 'Saudi Arabia', lat: 21.4858, lon: 39.1925, tzOffset: 3),
  City(name: 'Riyadh', country: 'Saudi Arabia', lat: 24.7136, lon: 46.6753, tzOffset: 3),
  City(name: 'Dubai', country: 'UAE', lat: 25.2048, lon: 55.2708, tzOffset: 4),
  City(name: 'Abu Dhabi', country: 'UAE', lat: 24.4539, lon: 54.3773, tzOffset: 4),
  City(name: 'Doha', country: 'Qatar', lat: 25.2854, lon: 51.5310, tzOffset: 3),
  City(name: 'Kuwait City', country: 'Kuwait', lat: 29.3759, lon: 47.9774, tzOffset: 3),
  City(name: 'Muscat', country: 'Oman', lat: 23.5880, lon: 58.3829, tzOffset: 4),
  City(name: 'Baghdad', country: 'Iraq', lat: 33.3152, lon: 44.3661, tzOffset: 3),
  City(name: 'Cairo', country: 'Egypt', lat: 30.0444, lon: 31.2357, tzOffset: 2),
  City(name: 'Istanbul', country: 'Turkiye', lat: 41.0082, lon: 28.9784, tzOffset: 3),
  City(name: 'Ankara', country: 'Turkiye', lat: 39.9334, lon: 32.8597, tzOffset: 3),
  City(name: 'Tehran', country: 'Iran', lat: 35.6892, lon: 51.3890, tzOffset: 3.5),
  // South & Southeast Asia
  City(name: 'Karachi', country: 'Pakistan', lat: 24.8607, lon: 67.0011, tzOffset: 5),
  City(name: 'Lahore', country: 'Pakistan', lat: 31.5204, lon: 74.3587, tzOffset: 5),
  City(name: 'Islamabad', country: 'Pakistan', lat: 33.6844, lon: 73.0479, tzOffset: 5),
  City(name: 'Delhi', country: 'India', lat: 28.6139, lon: 77.2090, tzOffset: 5.5),
  City(name: 'Mumbai', country: 'India', lat: 19.0760, lon: 72.8777, tzOffset: 5.5),
  City(name: 'Hyderabad', country: 'India', lat: 17.3850, lon: 78.4867, tzOffset: 5.5),
  City(name: 'Kolkata', country: 'India', lat: 22.5726, lon: 88.3639, tzOffset: 5.5),
  City(name: 'Kathmandu', country: 'Nepal', lat: 27.7172, lon: 85.3240, tzOffset: 5.75),
  City(name: 'Colombo', country: 'Sri Lanka', lat: 6.9271, lon: 79.8612, tzOffset: 5.5),
  City(name: 'Jakarta', country: 'Indonesia', lat: -6.2088, lon: 106.8456, tzOffset: 7),
  City(name: 'Kuala Lumpur', country: 'Malaysia', lat: 3.1390, lon: 101.6869, tzOffset: 8),
  City(name: 'Singapore', country: 'Singapore', lat: 1.3521, lon: 103.8198, tzOffset: 8),
  City(name: 'Bangkok', country: 'Thailand', lat: 13.7563, lon: 100.5018, tzOffset: 7),
  City(name: 'Manila', country: 'Philippines', lat: 14.5995, lon: 120.9842, tzOffset: 8),
  // East Asia & Oceania
  City(name: 'Tokyo', country: 'Japan', lat: 35.6762, lon: 139.6503, tzOffset: 9),
  City(name: 'Seoul', country: 'South Korea', lat: 37.5665, lon: 126.9780, tzOffset: 9),
  City(name: 'Beijing', country: 'China', lat: 39.9042, lon: 116.4074, tzOffset: 8),
  City(name: 'Hong Kong', country: 'China', lat: 22.3193, lon: 114.1694, tzOffset: 8),
  City(name: 'Sydney', country: 'Australia', lat: -33.8688, lon: 151.2093, tzOffset: 10),
  City(name: 'Melbourne', country: 'Australia', lat: -37.8136, lon: 144.9631, tzOffset: 10),
  City(name: 'Auckland', country: 'New Zealand', lat: -36.8485, lon: 174.7633, tzOffset: 12),
  // Europe
  City(name: 'London', country: 'United Kingdom', lat: 51.5074, lon: -0.1278, tzOffset: 0),
  City(name: 'Paris', country: 'France', lat: 48.8566, lon: 2.3522, tzOffset: 1),
  City(name: 'Berlin', country: 'Germany', lat: 52.5200, lon: 13.4050, tzOffset: 1),
  City(name: 'Amsterdam', country: 'Netherlands', lat: 52.3676, lon: 4.9041, tzOffset: 1),
  City(name: 'Madrid', country: 'Spain', lat: 40.4168, lon: -3.7038, tzOffset: 1),
  City(name: 'Rome', country: 'Italy', lat: 41.9028, lon: 12.4964, tzOffset: 1),
  City(name: 'Vienna', country: 'Austria', lat: 48.2082, lon: 16.3738, tzOffset: 1),
  City(name: 'Stockholm', country: 'Sweden', lat: 59.3293, lon: 18.0686, tzOffset: 1),
  City(name: 'Oslo', country: 'Norway', lat: 59.9139, lon: 10.7522, tzOffset: 1),
  City(name: 'Moscow', country: 'Russia', lat: 55.7558, lon: 37.6173, tzOffset: 3),
  // North America
  City(name: 'New York', country: 'USA', lat: 40.7128, lon: -74.0060, tzOffset: -5),
  City(name: 'Los Angeles', country: 'USA', lat: 34.0522, lon: -118.2437, tzOffset: -8),
  City(name: 'Chicago', country: 'USA', lat: 41.8781, lon: -87.6298, tzOffset: -6),
  City(name: 'Houston', country: 'USA', lat: 29.7604, lon: -95.3698, tzOffset: -6),
  City(name: 'San Francisco', country: 'USA', lat: 37.7749, lon: -122.4194, tzOffset: -8),
  City(name: 'Toronto', country: 'Canada', lat: 43.6532, lon: -79.3832, tzOffset: -5),
  City(name: 'Montreal', country: 'Canada', lat: 45.5017, lon: -73.5673, tzOffset: -5),
  City(name: 'Vancouver', country: 'Canada', lat: 49.2827, lon: -123.1207, tzOffset: -8),
  // Africa
  City(name: 'Lagos', country: 'Nigeria', lat: 6.5244, lon: 3.3792, tzOffset: 1),
  City(name: 'Nairobi', country: 'Kenya', lat: -1.2921, lon: 36.8219, tzOffset: 3),
  City(name: 'Johannesburg', country: 'South Africa', lat: -26.2041, lon: 28.0473, tzOffset: 2),
  City(name: 'Casablanca', country: 'Morocco', lat: 33.5731, lon: -7.5898, tzOffset: 1),
];

City cityByName(String name) {
  for (final c in cities) {
    if (c.name == name) return c;
  }
  return cities.first; // Dhaka
}
