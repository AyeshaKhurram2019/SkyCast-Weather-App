import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SkyCastApp());
}

class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyCast',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WeatherHomeScreen(),
    );
  }
}

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Weather Variables
  String cityName = "Lahore";
  double temperature = 0.0;
  String weatherCondition = "Loading...";
  int humidity = 0;
  double windSpeed = 0.0;
  bool isLoading = true;
  String errorMessage = "";

  // Securely fetching API Key compiled via --dart-define
  final String apiKey = const String.fromEnvironment('WEATHER_API_KEY', defaultValue: 'YOUR_DEFAULT_API_KEY');

  @override
  void initState() {
    super.initState();
    fetchWeather(cityName);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cityName = data['name'];
          temperature = data['main']['temp'].toDouble();
          weatherCondition = data['weather'][0]['main'];
          humidity = data['main']['humidity'];
          windSpeed = data['wind']['speed'].toDouble();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "City not found! Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "No Internet Connection or Server Error.";
        isLoading = false;
      });
    }
  }

  // Dynamic Background Colors based on Weather
  List<Color> getBackgroundColors() {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return [Colors.orangeAccent, Colors.blueAccent];
      case 'clouds':
        return [Colors.blueGrey.shade400, Colors.blueGrey.shade700];
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return [Colors.indigo.shade600, Colors.grey.shade900];
      default:
        return [Colors.blue.shade300, Colors.blue.shade700];
    }
  }

  // Dynamic Weather Icons
  IconData getWeatherIcon() {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.cloud_queue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: getBackgroundColors(),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter city name...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white, size: 28),
                      onPressed: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          fetchWeather(_searchController.text.trim());
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Main Content Area
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : errorMessage.isNotEmpty
                          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
                          : RefreshIndicator(
                              onRefresh: () => fetchWeather(cityName),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cityName,
                                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Icon(getWeatherIcon(), size: 100, color: Colors.white),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${temperature.toStringAsFixed(1)}°C',
                                      style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      weatherCondition,
                                      style: const TextStyle(color: Colors.white70, fontSize: 24, fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 50),

                                    // Weather Stats Cards
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildWeatherStatCard(Icons.water_drop, 'Humidity', '$humidity%'),
                                        _buildWeatherStatCard(Icons.air, 'Wind', '${windSpeed.toStringAsFixed(1)} m/s'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherStatCard(IconData icon, String title, String value) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
