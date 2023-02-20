import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_lambda/http_service.dart';
import 'package:flutter_aws_lambda/post_model.dart';

class detailed_hotels_Screen extends StatefulWidget {

  final int id;
  const detailed_hotels_Screen({Key? key, required this.id}) : super(key: key);

  @override
  State<detailed_hotels_Screen> createState() => _DetailedHotelsScreenState();

}


void launchURL(String _url) async {
  Uri uri = Uri.parse(_url);

  if(await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $_url';
  }

}

class _DetailedHotelsScreenState extends State<detailed_hotels_Screen> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pet friendly hotels"),

          actions: [

            IconButton(
              icon: const Icon(Icons.assignment_return),
              onPressed: () {
                setState(() {});
              },

            ),
          ],
        ),
        body: FutureBuilder(

          future: httpService.postParam(widget.id),

          //future: httpService.getPosts(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasData) {
              print("data" + snapshot.toString());
              List<Post> posts = snapshot.data!;


              return ListView(
                children: [
              Column(
              children: [

              Text(posts.first.hotel_name.toString(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Spacer(),
              Image.network(posts.first.photo1.toString(), width: 250.0),
              Spacer(),
              Image.network(posts.first.photo2.toString(), width: 250.0),
              Spacer(),
              Image.network(posts.first.photo3.toString(), width: 250.0),
              Spacer(),
              ],
              ),

              Text("Address: " + posts.first.address.toString()),
              Text("Total Rating: " + posts.first.star_rating),
              Text("Average Rating: " + posts.first.rating_avg),
              Text("Price: \$" + posts.first.start_price.toString()),
              Text(posts.first.description.toString()),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  FloatingActionButton.extended( label: Text('Call'), onPressed: (){}),
                  FloatingActionButton.extended(label: Text('Website'), onPressed: (){  launchURL(posts.first.url); }),
                  ],
                  ),
                ],
                ),
                    ],
              );

            }

            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

}