import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:location/location.dart';
import 'dart:async';
import '../screens/loginScreen.dart';
import '../screens/leaderboardScreen.dart';
import '../screens/personalScoreScreen.dart';
import '../screens/beastiesScreen.dart';

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
  BitmapDescriptor sourceIcon;
  BitmapDescriptor beastieOne;
  BitmapDescriptor beastieTwo;
  BitmapDescriptor beastieThree;

  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });

    setIcons();

    setInitialLocation();

  }

  //Free use icons come from https://game-icons.net/
  //Setting up icon for player
  void setIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/plane-pilot.png');

    //setting up icons for temp beasties
    beastieOne = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/eagle-emblem.png');

    beastieTwo = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/angler-fish.png');

    beastieThree = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/bully-minion.png');
  }

  //setting initial location
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  //function to show markers on google maps of beasties and player
  void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    //Player marker
    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon
    ));
    //Beastie markers
    var pinPositionOne = LatLng(currentLocation.latitude + 0.005 , currentLocation.longitude + 0.005);

    _markers.add(Marker(
      markerId: MarkerId('beastieOne') ,
      position: pinPositionOne,
      icon: beastieOne
    ));

    var pinPositionTwo = LatLng(currentLocation.latitude + 0.01 , currentLocation.longitude + 0.01);

    _markers.add(Marker(
      markerId: MarkerId('beastieTwo') ,
      position: pinPositionTwo,
      icon: beastieTwo
    ));

    var pinPositionThree = LatLng(currentLocation.latitude -0.005 , currentLocation.longitude - 0.005);

    _markers.add(Marker(
      markerId: MarkerId('beastieThree') ,
      position: pinPositionThree,
      icon: beastieThree
    ));

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
        icon: sourceIcon
      ));
    });
      
  }

   void changePage(int pagePicked) {

     if(pagePicked==4){
       Navigator.push(
       context,
         MaterialPageRoute(builder: (context) => loginScreen())
       );
     }

     if(pagePicked==3){
      Navigator.push(
         context,
       MaterialPageRoute(builder: (context) => leaderboardScreen())
       );
   }

     if(pagePicked==2){
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => personalScoreScreen())
      );
     }

     if(pagePicked==1){
       Navigator.push(
         context,
        MaterialPageRoute(builder: (context) => beastiesScreen())
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
        backgroundColor: Colors.blue
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

              print('test');

              showPinsOnMap();
          })
        ],
      ),
    );
  }
}

class MathGo extends StatefulWidget {
  final String title;

  const MathGo({Key key, this.title}) : super(key: key);

  State createState() => _MathGoState();
}

/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:location/location.dart';
import 'dart:async';
import '../screens/leaderboardScreen.dart';
import '../screens/personalScoreScreen.dart';
import '../screens/beastiesScreen.dart';
import '../screens/loginScreen.dart';
import '../widgets/mainMap.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 45;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(45.512230, -122.658722);

//Resource Used for Google Map Implementation: https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#4

bool isSwitched = false;

class MathGoApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp( 
          theme: theme,
          home: MathGo(title: 'Math GO! Map')
        );
        }
      );
  }
}

class _MathGoState extends State<MathGo> {
  //brightness variable
  Brightness brightness;

  //map variables
  LocationData currentLocation;
  Location location;
  Set<Marker> _markers = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;
  int pageIndex = 0;

  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });

    setSourceIcons();

    setInitialLocation();

  }

  void setSourceIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
        'assets/plane-pilot.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon
    ));
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
        icon: sourceIcon
      ));
    });
      
  }

  void changePage(int pagePicked) {

    if(pagePicked==4){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginScreen())
      );
    }
    if(pagePicked==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => leaderboardScreen())
      );
    }
    if(pagePicked==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => personalScoreScreen())
      );
    }
    if(pagePicked==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => beastiesScreen())
      );
    }
    if(pagePicked==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MathGoApp())
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
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('Dark Mode'),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
                });
              },
              activeTrackColor: Colors.green,
              activeColor: Colors.white
            )
          ])
        ])
      ),
      /*
      appBar: AppBar(
        title: Text('Math GO! Map Screen'),
        backgroundColor: Colors.blue
      ),
      */
      body: Stack(
        children: <Widget>[
          GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // my map has completed being created;
              // i'm ready to show the pins on the map
              showPinsOnMap();
          })
        ],
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
              icon: Icon(Icons.list),
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
    );
  }
}

class MathGo extends StatefulWidget {
  final String title;

  const MathGo({Key key, this.title}) : super(key: key);

  State createState() => _MathGoState();
}
*/