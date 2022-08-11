// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:weather/api/api.dart';
// import 'package:http/http.dart' as http;

// import 'package:weather/model/weather_response.dart';
// // import 'package:http/http.dart';

// class WeatherPage extends StatefulWidget {
//   const WeatherPage({Key? key}) : super(key: key);

//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }

// class _WeatherPageState extends State<WeatherPage> {
//   TextEditingController city = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//     GetWeather(city.text);
//   }

//   // Main? test;

//   // GetWeather() {
//   //   API().getWeather().then((value) {
//   //     setState(() {
//   //       test = value;
//   //     });
//   //     print(test!.temp);
//   //   });
//   // }

//   var data;
//   String? description;

//   GetWeather(String cityname) async {
//     String baseurl = 'https://api.openweathermap.org/data/2.5/weather?q=London';

//     String api = '2bc8cb507029966375f0a260ed62b586';
//     var url = Uri.parse('$baseurl$cityname&appid=$api');

//     // Await the http get response, then decode the json-formatted response.
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var title = jsonDecode(response.body);
//       setState(() {
//         // data = title['main']['temp'];
//         description = title['weather'][0]['description'];
//       });
//       // print(data);
//       print(description);
//     } else {
//       throw Exception('Error Weather');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all((50)),
//         child: Column(
//           children: [
//             Text('${description}'),
//             TextField(
//               controller: city,
//               decoration: InputDecoration(label: Text("Search city name")),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

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
  String location = 'San Francisco';
  String weather = 'Clear';
  String description = '';

  String searchUrl = 'https://api.openweathermap.org/data/2.5/weather?q=';
  String api = '2bc8cb507029966375f0a260ed62b586';

  void getSearch(String cityname) async {
    var url = Uri.parse('$searchUrl ' + cityname + "&appid=$api");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        location = data['name'];
        temperature = data['main']['temp'].round();
        weather = data['weather'][0]['main'];
        description = data['weather'][2]['description'];
      });
    } else {
      throw Exception('Error Weather');
    }
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    var url = Uri.parse(
        '$searchUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$api&units=metric');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data = data['main']['temp'];
    } else {
      throw Exception('Error Weather');
    }
  }

  void onSubmittedText(String cityname) async {
    setState(() {
      getSearch(cityname);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: getLocationWeather,
            child: Icon(Icons.location_on_outlined),
          ),
        ],
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/$weather.png'),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      temperature.toString() + ' °C',
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      weather,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    decoration: const InputDecoration(
                      hintText: 'Search  location...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                    onSubmitted: (String cityname) {
                      onSubmittedText(cityname);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
