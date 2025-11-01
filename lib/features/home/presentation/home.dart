import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create a GlobalKey to access the ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // Assign the key to the Scaffold
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:  <Widget>[
              DrawerHeader(
                
                
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
           Spacer(),
              ListTile(
                leading:IconButton(
                  icon: Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    // Handle logout action
                    
                  },
                ),
                title: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.yellow),
          onPressed: () {
            // Use the GlobalKey to open the drawer
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Home',
          style: TextStyle(fontSize: 24, color: Colors.yellow),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
