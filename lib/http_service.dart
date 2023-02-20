

import 'dart:convert';

import 'package:flutter_aws_lambda/post_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class HttpService {

  final String postURL = "https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_A_petHotel";

  final String postURL2 = "https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_pethotels2";

  final String postURL3 = "https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_hotel_with_name";

  final String postURL4 = "https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_hotel_OR";

  final String postURL5 = "https://vdg8o9gq6i.execute-api.ap-south-1.amazonaws.com/dev/fetch_hotel_chunks";


  Future<List<Post>> getPosts() async {

    Response response = await get(Uri.parse(postURL));

    print("hello" + response.body);

    if(response.statusCode == 200) {

      List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

     // List<Post> posts = body.map((dynamic item) => Post.fromJson((item)).toList());

      return posts;
    } else {
      throw "cannot retrieve posts";
    }



  }




//to retrieve 1 specified pet hotel with hard coded param for id
  Future<List<Post>> postPosts() async {
    
    final uri = Uri.parse(postURL2);
    
    // final headers = {
    //   'Content-Type': 'application/json' ,
    //   'Accept': '*/*'};

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'hotel_id': 10717};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);

      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }



  }



//to retrieve 1 specified pet hotel with param
  Future<List<Post>> postParam( int _id) async {

    final uri = Uri.parse(postURL2);

    // final headers = {
    //   'Content-Type': 'application/json' ,
    //   'Accept': '*/*'};

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'hotel_id': _id};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);

      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }



  }


  //retrieve hotels using get_hotel_chunk
  Future<List<Post>> retrieveHotels( String _index) async {

    final uri = Uri.parse(postURL5);

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'start_from': _index.toString()};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if(response.statusCode == 200) {

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();

      return posts;
    } else {
      throw "cannot retrieve posts";
    }



  }


  //to retrieve 1 specified pet hotel
  Future<List<Post>> postHotelName() async {
    
    final uri = Uri.parse(postURL3);

    final headers = {
      'Content-Type': 'application/json' ,
      'Accept': '*/*'};

    Map<String, dynamic> body = {'hotel_name': "Bangkok"};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);
      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }

  }

  //to retrieve 1 specified pet hotel using OR lambda function
  Future<List<Post>> postHotelORnoParam() async {

    final uri = Uri.parse(postURL4);

    // final headers = {
    //   'Content-Type': 'application/json' ,
    //   'Accept': '*/*'};

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'hotel_name': 'Ban'};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);
      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }

  }



  //to retrieve 1 specified pet hotel using OR lambda function
  Future<List<Post>> postHotelOR(String _keyword) async {

    final uri = Uri.parse(postURL4);

    // final headers = {
    //   'Content-Type': 'application/json' ,
    //   'Accept': '*/*'};

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'hotel_name': _keyword, 'address': _keyword};

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);
      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }

  }



  //to retrieve 1 specified pet hotel using OR lambda function
  Future<List<Post>> postHotelORFilter(String _keyword, String _order_by, String _order_type, String _index) async {

    final uri = Uri.parse(postURL4);

    // final headers = {
    //   'Content-Type': 'application/json' ,
    //   'Accept': '*/*'};

    final headers = {'Content-Type': 'text/plain'};

    Map<String, dynamic> body = {'city': _keyword, 'order_by': _order_by, 'order_type': _order_type, 'start_from': _index };

    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    //print("hello" + response.body);

    if(response.statusCode == 200) {

      //print(response.body);
      // List<dynamic> body = jsonDecode(response.body).cast<Map<String, dynamic>>();

      // List<Post> posts = body.map<Post>((json) => Post.fromJson(json)).toList();

      List<dynamic> responseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Post> posts = responseBody.map<Post>((json) => Post.fromJson(json)).toList();
      //Future<List<Post>> responseBody = response.body;

      return posts;
    } else {
      throw "cannot retrieve posts";
    }

  }



}