
import 'package:flutter/material.dart';
import 'package:flutter_aws_lambda/http_service.dart';
import 'package:flutter_aws_lambda/post_model.dart';
import 'package:flutter_aws_lambda/screen_detailed_hotels.dart';
import 'package:url_launcher/url_launcher.dart';

class PostsPage extends StatefulWidget {

  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PetHotelsScreenState();

}



void changeScreen(BuildContext _context, int _id) {

  Navigator.push(_context, MaterialPageRoute(builder: (context) => detailed_hotels_Screen(id: _id)),);
}


void launchURL(String _url) async {
  Uri uri = Uri.parse(_url);


 if( _url != null) {
   launchUrl(uri);
 } else {
   throw 'Could not launch $_url';
 }

}


  class _PetHotelsScreenState extends State<PostsPage> {

    final HttpService httpService = HttpService();

    int chunk_index = 0;
    int order_val = 0;
    int location_val = 0;
    String _order_type = "";
    String _order_by = "";

    String _keyword = "";

    List<String> search_text = [
      "Bangkok",
      "Chiang Mai"
    ];

    List<String> suggestion_text = [
      "Bangkok",
      "Chiang Mai"
    ];

    String s_hotel_name = "";
    String s_price = "";


    String s_description ="";


    @override
    void initState() {

      initSearchBar();

    super.initState();
  }


  void initSearchBar() async {


  }


  @override
    Widget build(BuildContext context) {







      return Scaffold(
          appBar: AppBar(

            actions: [


              // IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () {
              //     setState(() {});
              //   },
              //
              // ),


              Spacer(),

              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate(search_text, search_text),
                  );
                },

              ),
              Spacer(),
            ],
          ),
          body:

          SingleChildScrollView(  scrollDirection: Axis.vertical,
                  child: Column( children: [

                    filterContainer,
                    FutureBuilder(

                      future: order_val == 0 ? httpService.retrieveHotels(chunk_index.toString()) :
                      order_val == 1 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
                      order_val == 2 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
                      order_val == 3 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
                      order_val == 4 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
                      httpService.getPosts(),

                      //future: order_val == 0 ? httpService.retrieveHotels(chunk_index) : httpService.postHotelORnoParam(),

                      //futurer: httpService.postHotelORFilter(_order_by, _order_type, _start_from),
                      //future: httpService.getPosts(),
                      //future: httpService.postPosts(),
                      //future: httpService.postHotelName(),

                      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                        if (snapshot.hasData) {
                          //print("data" + snapshot.toString());
                          List<Post> posts = snapshot.data!;

                          return ListView(

                            shrinkWrap: true,
                            children: posts.map((Post post) {

                              var max_length = 15;
                              var name_length = post.hotel_name.length;
                              if(name_length >= max_length) {
                                var diff_length = name_length - max_length;
                                var use_length = name_length - diff_length;
                                s_hotel_name = post.hotel_name.substring(0,  use_length);
                                s_hotel_name = s_hotel_name + "...";
                              }

                              var var_price = post.start_price;

                              if(!post.start_price.isEmpty) {
                                s_price = "Prices from: $var_price baht";
                              } else {
                                s_price = "Prices from: ?? baht";
                              }


                              var max_desc_length = 100;
                              var desc_length = post.description.length;
                              if(desc_length >= max_desc_length) {
                                var diff_desc_length = desc_length - max_desc_length;
                                var use_desc_length = desc_length - diff_desc_length;
                                s_description = post.description.substring(0, use_desc_length);
                                s_description = s_description + "...";
                              }

                              return Card( child: Container( width: double.infinity, height: 150.0,
                                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                    Container( padding: EdgeInsets.fromLTRB(0, 0, 0, 0), width: 150, height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(post.photo1.toString(),),
                                          fit: BoxFit.fill ,
                                        ),
                                      ),
                                    ),

                                    Container( padding: EdgeInsets.fromLTRB(0, 10, 0, 0), alignment: Alignment.topCenter, child: SizedBox( width: 100.0, height: 100.0, child:
                                    Column(children: [
                                      Text(s_hotel_name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                                      Center(child: Text(s_price, style: TextStyle(fontSize: 8)),),

                                    ],),),
                                    ),

                                    Container(child: Column( children: [
                                        ElevatedButton(onPressed: ( ){ changeScreen(context, post.hotel_id); }, child: Text("details")),
                                        ElevatedButton(onPressed: ( ){ launchURL(post.url); }, child: Text("website")),],),
                                    ),

                                  ],
                                  ),
                                ),
                              );
                            },
                            ).toList(),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),

                  ],  )
              ),
      );

    }

    Widget sortByWidget() {return Container(child: Row(children: [

      Text("Sort By: ", textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),

      DropdownButton(
          value: order_val,
          items: const [
            DropdownMenuItem(
              child: Text("Alphabetical", style: TextStyle(fontSize: 11)),
              value: 0,
            ),
            DropdownMenuItem(
              child: Text("Price (High-Low)", style: TextStyle(fontSize: 11)),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("Price (Low-High)", style: TextStyle(fontSize: 11)),
              value: 2,
            ),
            DropdownMenuItem(
              child: Text("Rating (High-Low)", style: TextStyle(fontSize: 11)),
              value: 3,
            ),
            DropdownMenuItem(
              child: Text("Rating (Low-High)", style: TextStyle(fontSize: 11)),
              value: 4,
            ),

          ],
          onChanged: (value) {
            setState(() {
              order_val = value as int;

              switch(order_val) {

                case 0:
                  _order_type = "";
                  _order_by = "";

                  break;

                case 1:
                  _order_type = 'start_price';
                  _order_by = 'DESC';

                  break;
                case 2:
                  _order_type = 'start_price';
                  _order_by = 'ASC';
                  break;

                case 3:
                  _order_type = 'star_rating';
                  _order_by = 'DESC';

                  break;

                case 4:
                  _order_type = 'star_rating';
                  _order_by = 'ASC';

                  break;

                default:
                  _order_type = 'start_price';
                  _order_by = 'ASC';

                  break;

              }

            });
          }),
    ],),);}


    Widget locationWidget() {
      return Container(child: Row(children: [

        Text("Locations: ", textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
        DropdownButton(
          value: location_val,
          items: const [
            DropdownMenuItem(
              child: Text("Thailand", style: TextStyle(fontSize: 11)),
              value: 0,
            ),
            DropdownMenuItem(
              child: Text("Bangkok", style: TextStyle(fontSize: 11)),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("Chiang Mai", style: TextStyle(fontSize: 11)),
              value: 2,
            ),
          ], onChanged: (value) {
          setState(() {
            location_val = value as int;
            switch(value) {
              case 0:
                _keyword = "";
                break;
              case 1:
                _keyword = "Bangkok";
                break;
              case 2:
                _keyword = "Chiang Mai";
                break;
            }
          });
        },),
      ],),
      );
    }


    late Widget filterContainer =  Container(
      child:  Column( children: [

        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

          Container(
            //color: const Color(0xffeeee00),
            width: 200.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon( icon: Icon(Icons.filter_alt_outlined), onPressed: (){}, label: Text("Filters")),
          ),

          locationWidget(),
          sortByWidget(),

          Container(
            width: 200.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon( icon: Icon(Icons.sort_outlined), onPressed: (){}, label: Text("Sorting")),
          ),

          Container(
            width: 200.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon( icon: Icon(Icons.accessibility_new), onPressed: (){}, label: Text("Type")),
          ),






        ],),
      ),
    ],
    )
    );






  }







class MySearchDelegate extends SearchDelegate<String> {


  final List<String> AllHotels;
  final List<String> HotelsSuggestion;

  MySearchDelegate(this.AllHotels, this.HotelsSuggestion);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {

        if(query.isEmpty) {

         close(context, query);
        } 

        
        else {
          query = '';
        }
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, query));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> AllLocs = AllHotels.where((SingHotels) =>
    SingHotels.toLowerCase().contains(query.toLowerCase(),
      ),
    ).toList();

    return ListView.builder(
      itemCount: AllLocs.length,
      itemBuilder: (context, index) => ListTile(
        title:Text(AllLocs[index]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> AllSuggest = HotelsSuggestion.where((placeSuggestion) =>
    placeSuggestion.toLowerCase().contains(query.toLowerCase(),
      ),
    ).toList();

    return ListView.builder(
      itemCount: AllSuggest.length,
      itemBuilder: (context, index) => ListTile(
        title:Text(AllSuggest[index]),
      ),
    );
  }
  

}