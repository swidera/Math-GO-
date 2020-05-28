import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:location/location.dart';
import 'package:math_go/models/getLeaderboard.dart';
import 'dart:async';
import '../screens/loginScreen.dart';
import '../screens/leaderboardScreen.dart';
import '../screens/personalScoreScreen.dart';
import '../screens/beastiesScreen.dart';
import '../models/getPersonalScore.dart';
import '../models/getLeaderboard.dart';
import 'beastieAR.dart';
import '../models/getBeasties.dart';
import '../models/populateRandomBeasties.dart';
import 'dart:math';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 60;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(45.512230, -122.658722);

//Resource Used for Google Map Implementation: https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#4



class _MathGoState extends State<MathGo> {
  //nav bar variables
  int pageIndex = 0;

  List<Widget> pageOptions = <Widget>[
  Text(
    'Main App'
  ),
  Text(
    'Beasties Page'
  ),
  Text(
    'Personal Score Page'
  ),
  Text(
    'Leaderboard'
  ),
  Text(
    'Logging out...'
  )
];

  //brightness variable
  Brightness brightness;

  //map variables
  LocationData currentLocation;
  Location location;
  Set<Marker> _markers = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  //BitMap Variables
  BitmapDescriptor sourceIcon;
  List<BitmapDescriptor> beastieBitMap = new List<BitmapDescriptor>();

  //Beastie Variables
  var beastieCount = 0;
  List<beastieInfo> beastiesToSpawn = new List<beastieInfo>();
  List<beastieInfo> testBeastiesToSpawn = new List<beastieInfo>();

  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });

    //TO DO: variable for list of beasties

    populateRandomBeasties(beastiesToSpawn);

    testBeastiesToSpawn.add(new beastieInfo("Eagle", "easy", "2 + 2", 4.0, '/assets/eagle-emblem.png'));

    setIcons(testBeastiesToSpawn);
    
    setInitialLocation();
  }

  //Free use icons come from https://game-icons.net/
  //Setting up icon for player
  Future<void> setIcons(List<beastieInfo> beastiesList) async {
    //TO DO: go through list and set up each icon
    Size imageSize = new Size(100, 100);
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: imageSize),
        'assets/plane-pilot.png');

    for(var i = 0; i < beastiesList.length; i++) {
      beastieBitMap[i] = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: imageSize),
          beastiesList[i].imageUrl.toString());
    }
  }

  //setting initial location
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  //function to show markers on google maps of beasties and player
  void showPinsOnMap(List<BitmapDescriptor> beastieBitMap, List<beastieInfo> beastiesList) {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    //Player marker
    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon,
    ));
    //Beastie markers

    //TO DO: go through list and add each marker
    for(var i = 0; i < beastieBitMap.length; i++) {
      var randX = new Random();
      var randY = new Random();

      var randLat = 0.0;
      var randLong = 0.0;

      randLat = (randX.nextInt(5) + 1)*0.001;
      randLong = (randY.nextInt(5) + 1) *0.001;

      var randPosition = LatLng(currentLocation.latitude + randLat, currentLocation.longitude + randLong);

      print('LAT LONG DATA BELOW:');
      print(randLat);
      print(randLong);
      //print(beastieBitMap[i].toString());

      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: randPosition,
        icon: beastieBitMap[i],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeastieAr(beastie: beastiesList[i])),
          );
        }
      ));
    }
    
    setState(() {});
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {

      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere(
        (m) => m.markerId.value == 'sourcePin');

      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon,
      ));
    });
      
  }

   void changePage(int pagePicked) async{

     if(pagePicked==4){
       Navigator.push(
       context,
         MaterialPageRoute(builder: (context) => loginScreen())
       );
     }

     if(pagePicked==3){
      List<leaderInfo> leaderboard = await getLeaderboard();
      Navigator.push(
         context,
       MaterialPageRoute(builder: (context) => leaderboardScreen(leaderboard, widget.loggedInUser))
       );
   }

     if(pagePicked==2){
      String lifeTimeScore = await getPersonalScore(widget.loggedInUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => personalScoreScreen(lifeTimeScore, widget.loggedInUser)
        )
      );
     }

     if(pagePicked==1){
       List<beastieInfo> myBeasties = await getUsersBeasties(widget.loggedInUser);
       Navigator.push(
         context,
        MaterialPageRoute(builder: (context) => beastiesScreen(myBeasties, widget.loggedInUser))
       );
     }

     setState(() {
       pageIndex = pagePicked;
     });
   }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION
    );

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude,
            currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
    }

    return Scaffold(
      //app bar 
      appBar: AppBar(
        title: Text('Math GO! Map Screen'),
        backgroundColor: Colors.orange
      ),
      bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                title: Text('Beasties'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.score),
                title: Text('Score'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Leaderboard'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.system_update_alt),
                title: Text('Logout'),
              ),
            ],
            currentIndex: pageIndex,
            selectedItemColor: Colors.deepOrangeAccent,
            onTap: changePage,
      ),
      body: Stack(
        children: <Widget>[
          //google map widget fall
          GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: true,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // my map has completed being created;
              // i'm ready to show the pins on the map

              showPinsOnMap(beastieBitMap, testBeastiesToSpawn);
          }),
        ],
      ),
    );
  }
}

class MathGo extends StatefulWidget {
  final String loggedInUser;
  const MathGo(this.loggedInUser);

  State createState() => _MathGoState();
}
