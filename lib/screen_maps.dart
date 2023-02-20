import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_lambda/http_service.dart';
import 'package:flutter_aws_lambda/post_model.dart';




/**
 *  Function to launch a URL to a browser
 */
void launchURL(String _url) async {
  Uri uri = Uri.parse(_url);

  //if(await canLaunchUrl(uri)) {
  if( _url != null) {
    launchUrl(uri);
  } else {
    throw 'Could not launch $_url';
  }

}


/**
 * mapScreen class
 * Screen containing the landing page for the pet friendly places,
 * currently using data from agoda hotels
 */
class mapsScreen extends StatefulWidget {

  const mapsScreen({Key? key}) : super(key: key);

  @override
  State<mapsScreen> createState() => _mapsScreenState();



}
/**
 * class mapsScreenState
 * containing the state for the mapScreen
 *
 */
class _mapsScreenState extends State<mapsScreen> {

  final HttpService httpService = HttpService(); //  http request object to retrieve data to parse from agoda hotels -> aws, hotels -> petfriendlyhotels

  late GoogleMapController googleMapController;

  static const CameraPosition initalCameraPosition = CameraPosition(target: LatLng(13.75, 100.50), zoom: 14);

  Set<Marker> markers = {};

  final itemKey = GlobalKey();


  String _order_type = "";
  String _order_by = "";
  String _keyword = "";
  int order_val = 0;
  int chunk_index = 0;
  List<Post> posts = [];


  List<String> search_text = [
    "Bangkok",
    "Chiang Mai"
  ];


  /**
   * initState function
   * calls initLocation to provide inital permissions and initalise location data
   */
  @override
  void initState() {
    initLocation();
  }

  /**
   * initLocation function
   * retrieves the current location of the device and moves the google map api to that location
   */
  void initLocation() async {

    // if(markers.isEmpty) {
    //   markers.clear();
    // }

    Position position = await _determineMyPosition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

    markers.add(Marker(markerId: const MarkerId('currentLocation'), infoWindow: InfoWindow(title: "Current Location"), position:  LatLng(position.latitude, position.longitude)));
    setState(() {});
  }


  /**
   * gotoLocation function
   * changes the position of google map api to latlong position
   */
  void gotoLocation(String _marker_name, double _lat, double _long) async {

    await googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _long), zoom: 14)));
    setState(() {});

  }

  /**
   * addMarkers function
   * adds a marker to the google map api
   * adds a onTap() method to reposition the camera to that location
   *
   * attempts to open sheet using id of the marker of post id
   */
  void addMarkers(int _hotel_id, String _marker_name, double _lat, double _long) async {
    //Position position = await Geolocator.getCurrentPosition();

    await markers.add(Marker(markerId: MarkerId(_marker_name), position:  LatLng(_lat, _long), infoWindow: InfoWindow(title: "$_marker_name", onTap: () {
      showModalBottomSheet(context: context, builder: (BuildContext bContext) {
        return detailedHotelSheet(_hotel_id);
      });

    }),
        onTap: () {
      gotoLocation(_marker_name, _lat, _long);
      //gotoCard();

      showModalBottomSheet(context: context, builder: (BuildContext bContext) {
        return detailedHotelSheet(_hotel_id);
      });

    } ));

    setState(() {});
  }

  /**
   * gotoCard function
   * provides the functionality to go to the index of the list
   * !! currently broken (?)
   */
  Future gotoCard() async {

    final context = itemKey.currentContext!;

    await Scrollable.ensureVisible(context);

  }


  /**
   * override build function
   * buildcontext of the state
   */
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
                  delegate: LeSearchDelegate(search_text, search_text),
                );
              },

            ),


          ],
        ),
        body: Stack( children: [

            GoogleMap(initialCameraPosition: initalCameraPosition, markers: markers, zoomControlsEnabled: false, mapType: MapType.normal, onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            }),

            filterContainer,

            currentLocationContainer,

            HotelCardContainer,

        ],


        )



            //return Center(child: CircularProgressIndicator()


    );


  }

  /**
   *    Function to retrieve the device's current position.
   *    Intends to retrieve current location using permission checks.
   *    Clears and adds the current location as a marker.
   *    sets states to refresh the screen to show current location on map.
   */
  Future<Position> _determineMyPosition() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }

    }

    if(permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }


  /**
   * details inside hotel card Container
   */
  Widget hotelDetailsContainer(String _hotel_name, String _hotel_desc, String _url) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[


          SizedBox(width: 150,
            child:Text(_hotel_name, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, softWrap: false,
          )


        ),
        SizedBox( height: 5,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(child: Icon(Icons.star,)),
              Container(child: Icon(Icons.star,)),
              Container(child: Icon(Icons.star,)),

          ],),
        ),

          SizedBox(width: 100,
              child:Text(_hotel_desc, style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis, softWrap: false,
              )
          ),

        Container( child: Row(
          children: [
            ElevatedButton( onPressed: (){ launchURL(_url); }, child: Text("Website", style: TextStyle(fontSize: 12.0,)),),
            ElevatedButton( onPressed: (){}, child: Text("Directions", style: TextStyle(fontSize: 12.0)),),
          ],
        ),
        ),

      ],
    );

  }


  /**
   * unused old _boxes factory function
   */
  Widget _boxes(String _image, double lat, double long, String _hotel_name) {
    return GestureDetector(
      onTap: () {
        //go to location / open details of hotel

      },
      child: Container(
        child:  FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196f3),
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),

                  ),
                ),
                Container(color: Colors.white,
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: null,
                ),)

              ],
            ),
          )
        ),
      )
    );
  }


  /**
   * Hotels card container
   *
   */
  late Widget HotelCardContainer = Expanded(flex: 2, child: Container( alignment: Alignment.bottomCenter,
    margin: EdgeInsets.fromLTRB(5, 400, 5, 10),
    height: 150.0,
    width: double.infinity,
    color: Color.fromARGB(0, 220, 220, 220),

   child: SingleChildScrollView( scrollDirection: Axis.horizontal,

   child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      FutureBuilder(

        future: order_val == 0 ? httpService.retrieveHotels(chunk_index.toString()) :
        order_val == 1 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
        order_val == 2 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
        order_val == 3 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
        order_val == 4 ?  httpService.postHotelORFilter(_keyword, _order_by, _order_type, chunk_index.toString()) :
        order_val == 9 ?  httpService.postHotelORFilter("", "start_price", "DESC", chunk_index.toString()) :
        httpService.getPosts(),


        //future: httpService.retrieveHotels(chunk_index.toString()),


        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if(snapshot.hasData) {
            //print("data" + snapshot.toString());
            List<Post> posts = snapshot.data!;



          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: posts.map((Post post) {

              addMarkers(post.hotel_id, post.hotel_name, double.parse(post.latitude), double.parse(post.longitude));

              return GestureDetector(
              onTap: () => {
                gotoLocation(post.hotel_name, double.parse(post.latitude), double.parse(post.longitude)),

                //open sheet if location is ==

                  showModalBottomSheet(context: context, builder: (BuildContext bContext) {
                  return detailedHotelSheet(post.hotel_id);
                  })
              },
              child: Card(child: Container(
                //key: itemKey,

                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                width: 360,
                height: 150,
                color: Colors.white,
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(24.0),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(post.photo1),
                        ),

                      ),
                    ),
                    Container(color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: hotelDetailsContainer(post.hotel_name, post.description, post.url),
                      ),),

                  ],
                ),


              ),
              ),
              );

                // _boxes(post.photo1, double.parse(post.latitude), double.parse(post.longitude), post.hotel_name),
                // _boxes(post.photo1, double.parse(post.latitude), double.parse(post.longitude), post.hotel_name),
                // _boxes(post.photo1, double.parse(post.latitude), double.parse(post.longitude), post.hotel_name),



              // return Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: _boxes(post.photo1, double.parse(post.latitude), double.parse(post.longitude), post.hotel_name),
              //
              // );


              //return _boxes(post.photo1, double.parse(post.latitude), double.parse(post.longitude), post.hotel_name);
            },
            ).toList(),
          );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),

    ],)
   ),

  ),
  );

  Widget dragDownContainer = Container(
    child: Icon(Icons.linear_scale_outlined),
  );


  /**
   * detailed sheet containing hotel details
   * to be called once the user taps on the card of the hotel
   */
  Widget detailedHotelSheet(int _hotel_id) {
    return Flexible(child:
    FutureBuilder(future: httpService.postParam(_hotel_id),

      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
      if (snapshot.hasData) {
        List<Post> hotel_list = snapshot.data!;
        return ListView(children: [Column(children: [
          Text(hotel_list.first.hotel_name.toString(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Image.network(hotel_list.first.photo1.toString(), width: 250.0),
              Spacer(),
              Image.network(hotel_list.first.photo2.toString(), width: 250.0),
              Spacer(),
              Image.network(hotel_list.first.photo3.toString(), width: 250.0),
              Spacer(),
            ],
          ),

          Text("Address: " + hotel_list.first.address.toString()),
          Text("Total Rating: " + hotel_list.first.star_rating),
          Text("Average Rating: " + hotel_list.first.rating_avg),
          Text("Price: \$" + hotel_list.first.start_price.toString()),
          Text(hotel_list.first.description.toString()),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended( label: Text('Call'), onPressed: (){}),
              FloatingActionButton.extended(label: Text('Website'), onPressed: (){  launchURL(hotel_list.first.url); }),
            ],
          ),



        ],)],);
      }
      return Center(child: CircularProgressIndicator());
      },
    )

    );
  }


  Widget filter_col1 = Column(
    children: [
      ElevatedButton.icon(icon: Icon(Icons.car_crash_outlined), onPressed: (){}, label: Text("Accomodates")),
      ElevatedButton.icon(icon: Icon(Icons.coffee_rounded), onPressed: (){}, label: Text("Cafe")),
      ElevatedButton.icon(icon: Icon(Icons.park_sharp), onPressed: (){}, label: Text("Park")),
      ElevatedButton.icon(icon: Icon(Icons.pool_sharp), onPressed: (){}, label: Text("Dog Pool")),
      ElevatedButton.icon(icon: Icon(Icons.shopping_bag), onPressed: (){}, label: Text("Pet Shop")),
      ElevatedButton.icon(icon: Icon(Icons.sports_baseball), onPressed: (){}, label: Text("Outdoor")),
    ],
  );

  Widget filter_col2 = Column(
    children: [
      ElevatedButton.icon(icon: Icon(Icons.hotel), onPressed: (){}, label: Text("Pet Hotels")),
      ElevatedButton.icon(icon: Icon(Icons.restaurant), onPressed: (){}, label: Text("Restaurant")),
      ElevatedButton.icon(icon: Icon(Icons.health_and_safety), onPressed: (){}, label: Text("health_and_safety")),
      ElevatedButton.icon(icon: Icon(Icons.brush), onPressed: (){}, label: Text("Dog brush")),
      ElevatedButton.icon(icon: Icon(Icons.school), onPressed: (){}, label: Text("School")),
      ElevatedButton.icon(icon: Icon(Icons.warehouse_rounded), onPressed: (){}, label: Text("Organisation")),
    ],
  );


  /**
   * filterBottomSheet when user filters through all filters
   */
  late Widget filterBottomSheet = Flexible( 

      child: Column( children: <Widget>[
        dragDownContainer,

        Text("Filter by",  style: const TextStyle(fontWeight: FontWeight.bold),),

        Text("Placeholder: filters",  style: const TextStyle(fontWeight: FontWeight.bold),),

        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          filter_col1,
          filter_col2
        ],),

      ],)


  );


  /**
   * Container for current Location.
   * calls the current location function.
   * refreshes the screen.
   */
  late Widget currentLocationContainer = Container(
    margin: EdgeInsets.fromLTRB(200, 0, 5, 180),
    alignment: Alignment.bottomRight,
    child: ElevatedButton.icon(onPressed: () async {

      Position position = await _determineMyPosition();

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18)));

      //markers.clear();
      markers.add(Marker(markerId: const MarkerId('currentLocation'), infoWindow: InfoWindow(title: "Current Location"), position:  LatLng(position.latitude, position.longitude)));
      setState(() {});


    }, icon: Icon(Icons.my_location), label: Text("Current Location")),
  );


  /**
   * Row containing the sorting items
   * Icon, text, dropdownbutton
   */
  late Widget sortingRow = Row(children: [
    Icon(Icons.sort_outlined),
    Text("Sorting: ", style: const TextStyle(fontWeight: FontWeight.bold),),

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

  ],
  );

  /**
   * Container for sorting row
   * Downdown button with text icon
   *
   */
  late Widget sortingContainer_old = Container(
    alignment: Alignment.center,
    child:
    sortingRow,
  );


  void parseSORTBY(String parse_ordertype, String parse_orderby, String parse_keyword, int parse_orderval) {
posts = [];
    _order_type = parse_ordertype;
    _order_by = parse_orderby;
    _keyword = parse_keyword;
    order_val = parse_orderval;
    print(order_val);
    print(_order_by);
    setState(() {

        Navigator.of(context).pop();
      //Navigator.pop(context);
      //Navigator.of(context).pop();
    });
  }

  late Widget sortingSheet = Flexible(
    child: Column(children: [

      dragDownContainer,
      Text("Sort by",  style: const TextStyle(fontWeight: FontWeight.bold),),

      ElevatedButton.icon(icon: Icon(Icons.abc), onPressed: (){ parseSORTBY("", "", "", 0); }, label: Text("Alphabetical")),
      ElevatedButton.icon(icon: Icon(Icons.attach_money), onPressed: (){ parseSORTBY("start_price", "DESC", "", 1); }, label: Text("Price: high - low")),
      ElevatedButton.icon(icon: Icon(Icons.attach_money), onPressed: (){ parseSORTBY("start_price", "ASC", "", 2); }, label: Text("Price: low - high")),
      ElevatedButton.icon(icon: Icon(Icons.stars), onPressed: (){ parseSORTBY("star_rating", "DESC", "", 3); }, label: Text("Rating: high - low")),
      ElevatedButton.icon(icon: Icon(Icons.stars), onPressed: (){ parseSORTBY("star_rating", "ASC", "", 4); }, label: Text("Rating: high - low")),

    ],),
  );


  late Widget sortingContainer = Container( alignment: Alignment.center,
    child: ElevatedButton.icon(icon: Icon(Icons.sort), onPressed: (){
      showModalBottomSheet(context: context, builder: (BuildContext bContext) {
        return sortingSheet;
      });

    }, label: Text("Sort By")),
  );

  late Widget petsFilterRow = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    ElevatedButton.icon(icon: Icon(Icons.adb), onPressed: (){}, label: Text("Cat")),
    ElevatedButton.icon(icon: Icon(Icons.pets), onPressed: (){}, label: Text("Dog")),
    ElevatedButton.icon(icon: Icon(Icons.catching_pokemon), onPressed: (){}, label: Text("lizards")),
    ElevatedButton.icon(icon: Icon(Icons.elderly_woman), onPressed: (){}, label: Text("old pet")),
  ],
  );

  late Widget accommodatesBottomSheet = Flexible(

      child: Column( children: <Widget>[
        dragDownContainer,

        Text("Filter by",  style: const TextStyle(fontWeight: FontWeight.bold),),

       petsFilterRow,

      ],)


  );


  late Widget accommodatesContainer = Container( alignment: Alignment.center,
    child: ElevatedButton.icon( icon: Icon(Icons.house), onPressed: (){
      showModalBottomSheet(context: context, builder: (BuildContext bContext) {
        return accommodatesBottomSheet;
      });

    }, label: Text("Accommodates")),
  );

  /**
   *
   * Sliding sorting row that calls other containers
   */
  late Widget filterContainer =  Container(
      child:  Column( children: [

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

            Container(
              width: 150.0,
              alignment: Alignment.center,
              child: ElevatedButton.icon( icon: Icon(Icons.filter_alt_outlined), onPressed: (){}, label: Text("Filters")),
            ),

            accommodatesContainer,

            sortingContainer,

            Container(
              width: 150.0,
              alignment: Alignment.center,
              child: ElevatedButton.icon( icon: Icon(Icons.accessibility_new), onPressed: (){
                
                showModalBottomSheet(isScrollControlled: true, context: context, builder: (BuildContext bContext) {
                  return filterBottomSheet;
                });

              }, label: Text("All")),
            ),

          ],),
        ),
      ],
      )
  );


}

class LeSearchDelegate extends SearchDelegate<String> {

  final List<String> All_Places;
  final List<String> Suggestions;

  LeSearchDelegate(this.All_Places, this.Suggestions);

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
    final List<String> AllLocs = All_Places.where((SingHotels) =>
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
    final List<String> AllSuggest = Suggestions.where((placeSuggestion) =>
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