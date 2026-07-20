import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 

void main() {
  runApp(const SkyCastApp());
}

class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), 
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
  // Variables for Data
  String cityName = "Rawalpindi"; 
  double tempInCelsius = 0.0;
  String weatherCondition = "Loading...";
  int humidity = 0;
  double windSpeed = 0.0;
  bool isCelsius = true;
  List hourlyForecast = [];
  bool isLoading = true;

  // 🟢 FIXED: Yeh line GitHub Secret (WEATHER_API_KEY) ko build ke waqt code mein integrate karegi
  static const String apiKey = String.fromEnvironment('WEATHER_API_KEY');

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 🟢 FIXED: Yahan ab dynamic 'apiKey' variable link ho gaya hai
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          tempInCelsius = data['list'][0]['main']['temp'].toDouble();
          weatherCondition = data['list'][0]['weather'][0]['main'];
          humidity = data['list'][0]['main']['humidity'];
          windSpeed = data['list'][0]['wind']['speed'].toDouble();
          hourlyForecast = data['list'].sublist(0, 8); 
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        weatherCondition = "City not found";
        isLoading = false;
      });
    }
  }

  double convertToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundGradient = weatherCondition.toLowerCase().contains('rain') 
        ? Colors.blueGrey.shade900 
        : Colors.blue.shade900;

    return Scaffold(
      backgroundColor: backgroundGradient,
      appBar: AppBar(
        title: const Text("SkyCast"), 
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isCelsius ? Icons.thermostat : Icons.text_fields),
            tooltip: isCelsius ? "Switch to °F" : "Switch to °C",
            onPressed: () {
              setState(() {
                isCelsius = !isCelsius; 
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search any city...",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      setState(() {
                        cityName = _searchController.text;
                      });
                      fetchWeatherData(); 
                    }
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : ListView( 
                      children: [
                        Text(
                          cityName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isCelsius 
                              ? "${tempInCelsius.toStringAsFixed(1)}°C"
                              : "${convertToFahrenheit(tempInCelsius).toStringAsFixed(1)}°F",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          weatherCondition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.white70),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.water_drop, color: Colors.blueAccent),
                                  const SizedBox(height: 5),
                                  const Text("Humidity", style: TextStyle(color: Colors.white60, fontSize: 12)),
                                  Text("$humidity%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              Container(width: 1, height: 40, color: Colors.white24), 
                              Column(
                                children: [
                                  const Icon(Icons.air, color: Colors.tealAccent),
                                  const SizedBox(height: 5),
                                  const Text("Wind Speed", style: TextStyle(color: Colors.white60, fontSize: 12)),
                                  Text("${windSpeed.toStringAsFixed(1)} m/s", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.white30),
                        const SizedBox(height: 20),
                        const Text(
                          "Hourly Forecast",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 150, 
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hourlyForecast.length,
                            itemBuilder: (context, index) {
                              final hourlyData = hourlyForecast[index];
                              final hourlyTemp = hourlyData['main']['temp'].toDouble();
                              final hourlyCond = hourlyData['weather'][0]['main'];
                              final time = hourlyData['dt_txt'].toString().substring(11, 16); 
                              
                              final double pop = hourlyData['pop'] != null ? hourlyData['pop'].toDouble() : 0.0;
                              final int rainChances = (pop * 100).round();

                              return Container(
                                width: 95,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(time, style: const TextStyle(color: Colors.white60)),
                                    Icon(
                                      hourlyCond.toLowerCase().contains('rain') ? Icons.thunderstorm : Icons.wb_cloudy,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "$rainChances% Rain",
                                      style: const TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      isCelsius
                                          ? "${hourlyTemp.toStringAsFixed(0)}°C"
                                          : "${convertToFahrenheit(hourlyTemp).toStringAsFixed(0)}°F",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
