import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../model/location.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double temperature = 0;
  String citylocation = 'San Francisco';
  String weather = 'Clear';
  String description = '';
  String icon = '01d';
  String pressure = '';
  String humidity = '';

  String searchUrl = 'https://api.openweathermap.org/data/2.5/weather?q=';
  String locationAPIUrl = 'https://api.openweathermap.org/data/2.5/weather?';
  String api = '2bc8cb507029966375f0a260ed62b586';

  void getSearch(String cityname) async {
    var url = Uri.parse('$searchUrl ' + cityname + "&appid=$api&units=metric");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        citylocation = data['name'];
        temperature = data['main']['temp'];
        weather = data['weather'][0]['main'];
        description = data['weather'][0]['description'];
        icon = data['weather'][0]['icon'];
        pressure = data['main']['pressure'];
      });
    } else {
      throw Exception('Error Weather');
    }
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    var url = Uri.parse(
        '${locationAPIUrl}lat=${location.latitude}&lon=${location.longitude}&appid=$api&units=metric');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        citylocation = data['name'];
        temperature = data['main']['temp'];
        weather = data['weather'][0]['main'];
        description = data['weather'][0]['description'];
        icon = data['weather'][0]['icon'];
        pressure = data['main']['pressure'];
      });
    } else {
      throw Exception('Error Weather');
    }
  }

  void onSubmittedText(String cityname) async {
    setState(() {
      getSearch(cityname);

      getIcon();
    });
  }

  Future<dynamic> getIcon() async {
    var url = Uri.parse("http://openweathermap.org/img/w/$icon");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        icon = data['weather'][0]['icon'];
      });
    } else {
      throw Exception('Error Weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF8379AA),
      body: Column(
        children: [
          Image.asset(
            'assets/weather.png',
            width: 100,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 280,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Search  location...',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                    onSubmitted: (String cityname) {
                      onSubmittedText(cityname);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 0,
              ),
              Container(
                  child: GestureDetector(
                onTap: getLocationWeather,
                child: Icon(Icons.location_on_outlined),
              )),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/$weather.png'),
                    fit: BoxFit.cover)),
          ),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/$weather.png'), fit: BoxFit.cover)),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          '$icon.png',
                          width: 300,
                        ),
                      ),
                      Center(
                        child: Text(
                          citylocation,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          description,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                SizedBox(
                    child: GestureDetector(
                  onTap: getLocationWeather,
                  child: Icon(Icons.location_on_outlined),
                )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(citylocation),
                ),
                Text(pressure),
              ],
            ),
          )
        ],
      ),
    );
  }
}
