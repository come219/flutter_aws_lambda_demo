import 'package:flutter/material.dart';
import 'package:flutter_aws_lambda/posts.dart';
import 'package:flutter_aws_lambda/screen_ScanQR.dart';
import 'package:flutter_aws_lambda/screen_detailed_hotels.dart';
import 'package:flutter_aws_lambda/screen_maps.dart';

class menuScreen extends StatefulWidget {

  const menuScreen({Key? key}) : super(key: key);

  @override
  State<menuScreen> createState() => _menuScreenState();

}

class _menuScreenState extends State<menuScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: Stack(

        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          ElevatedButton(child: Text('pet_hotels'), onPressed: (){

            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostsPage()),
              );
            });
          }),

          ElevatedButton(child: Text('detailed'), onPressed: (){

            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => detailed_hotels_Screen(id: 10717)),
              );
            });
          }),

          ElevatedButton(child: Text('google maps'), onPressed: (){

            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mapsScreen()),
              );
            });
          }),

          ElevatedButton(child: Text('QR CODE'), onPressed: (){

            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => scanQR_Screen()),
              );
            });
          }),

          ],
        ),
       ],
      ),
      ),
    );
  }


}