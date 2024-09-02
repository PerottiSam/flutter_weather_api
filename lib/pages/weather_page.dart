import 'package:flutter/material.dart';
import 'package:flutter_weather_api/models/weather_model.dart';
import 'package:flutter_weather_api/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key (yeah i'm not hiding it)
  final _weatherService = WeatherService("e3c143c68dd54fe88e7a99425adb4d33");
  WeatherModel? weatherModel;

  // fetch weather
  void _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        weatherModel = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? condition) {
    if (condition == null) {
      return 'assets/sunny.json';
    }

    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';

      case 'thunderstorm':
        return 'assets/thunder.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  //init
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(weatherModel?.cityName ?? "Loading city..."),

            // animation
            Lottie.asset(getWeatherAnimation(weatherModel?.mainCondition)),

            // temperature
            Text('${weatherModel?.temperature.round()}°C'),

            // weather condition
            Text(weatherModel?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
