/**
 *  main.dart file for flutter_aws_lambda flutter program
 *
 *  to retrieve the API data from the serverless Lambda function
 *  to parse the json data into a List type class of the petfriendly hotels
 *
 *  written by Sebastian St J, come219; 9/20/22
 */


//Import Libraries
import 'dart:convert';    //dart convert library
import 'package:flutter/foundation.dart'; //foundation flutter library
import 'package:flutter/material.dart';   //material dart library
import 'package:flutter_aws_lambda/posts.dart';
import 'package:flutter_aws_lambda/screen_detailed_hotels.dart';
import 'package:flutter_aws_lambda/screen_menu.dart';
import 'package:http/http.dart' as http;  //http call library
import 'dart:developer';
import 'package:flutter/rendering.dart';


/**
 * petfriendlyhotels class
 *
 * Class defining the attributes of the petfriendlyhotels
 * To contain all the fields described in the db Hotels in the table hotelxml
 */
class petfriendlyhotels {

  //attributes described by hotelxml table in Hotels db
  final int hotel_id;         //hotel id, primary key cannot be NULL
  final String hotel_name;   //hotel name
  final String city;         //hotel city
  final String star_rating;  //hotel star rating
  final String rating_avg;
  final String country;
  final String accommodation_type;
  final String url;
  final String photo1;
  final String photo2;
  final String photo3;
  final String zipcode;
  final String latitude;
  final String longitude;
  final String description;
  final String thai_name;
  final String thai_description;
  final String thai_list_amenities;
  final String list_amenities;
  final String start_price;


  //const type of petfriendlyhotels
  const petfriendlyhotels({
    required this.hotel_id,
    required this.hotel_name,
    required this.city,
    required this.star_rating,
    required this.rating_avg,
    required this.country,
    required this.accommodation_type,
    required this.url,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.thai_name,
    required this.thai_description,
    required this.thai_list_amenities,
    required this.list_amenities,
    required this.start_price
  });


  //factory method of petfriendlyhotels
  factory petfriendlyhotels.fromJson(Map<String, dynamic> json) {
    return petfriendlyhotels(
        hotel_id: json['hotel_id'] as int,
        hotel_name: json['hotel_name'] as String,
        city: json['city'] as String,
        star_rating: json['star_rating'] as String,
        rating_avg: json['rating_avg'] as String,
        country: json['country'] as String,
        accommodation_type: json['accommodation_type'] as String,
        url: json['url'] as String,
        photo1: json['photo1'] as String,
        photo2: json['photo2'] as String,
        photo3: json['photo3'] as String,
        zipcode: json['zipcode'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
        description: json['description'] as String,
        thai_name: json['thai_name'] as String,
        thai_description: json['thai_description'] as String,
        thai_list_amenities: json['thai_list_amenities'] as String,
        list_amenities: json['list_amenities'] as String,
        start_price: json['start_price'] as String

    );
  }
}


/**
 * _hotels List variable
 *
 * to contain all the parsed hotels in a callable global variable
 */
List<petfriendlyhotels> _hotels = [];

// String thishotels() {
//   String getalloutput= "";
// //getalloutput = _hotels[0].hotel_id.toString();
//   return getalloutput;
// }


/**
 * global output string
 *
 * used for testing parsing a string output to the screen
 */
String g_outputstring = "";


/**
 * Function to retrieve List from json to List
 *
 * @param responseBody   to contain the json response to be parsed
 * @return a parsed map of petfriendlyhotels as a List
 */
List<petfriendlyhotels> parseHotels(String responseBody) {

  print("3 - parsing hotels");
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<petfriendlyhotels>((json) => petfriendlyhotels.fromJson(json)).toList();
}
/**
 * Function to fetch from AWS Lambda server
 *
 * retrieves the json from the API URL
 * goes through procedure to parse the data
 *
 * @params url to contain the API URL
 * @params output call http get to URL
 * @return global _hotels variable
 */
Future<List<petfriendlyhotels>> fetchAWS() async {

  print("2 - fetching AWS");

  String url = 'https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_A_petHotel';  // Lambda API URL
  final output = await http.get(Uri.parse(url));  //http get URI URL

  g_outputstring = output.body; //parses the entire json body into g_outputstring

  // if(g_outputstring == null) {
  //   print("failed to retrieve out.body");
  // }

  //compute(parseHotels, output.body);  // legacy command --unsure

  // List<petfriendlyhotels> _hotels = await parseHotels(output.body); //call parse Hotels to send json body to become List
  _hotels = await parseHotels(output.body); //type 2 call parse Hotels to send json body directly to List

  return _hotels; //return List of hotels type petfriendlyhotels
}


/**
 * Function to get Hotels from fetch AWS function
 *
 * final List of hotels parsed into _hotels
 */
Future<void> getHotels() async {

  print("1 - Getting hotels from aws");

  final List<petfriendlyhotels> hotels = await fetchAWS();

  _hotels = hotels;

  //g_outputstring = _hotels[0].hotel_name;

}



/**
 * main function
 */
void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

      home: menuScreen(),
      //home: PostsPage(),
      //home: detailed_hotels_Screen(),
    );
  }
}

