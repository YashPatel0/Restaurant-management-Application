import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:restaurant_system/Screen/login/login.dart';
import 'package:restaurant_system/Screen/profile/manager_profile.dart';
import 'package:restaurant_system/Screen/bill/Bill.dart';

import '../../bill/BillHistory.dart';
import '../../item/item_list.dart';
import '../../staff/staff_List.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    EnterItemList(),
    StaffList(),
    Bill(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine the platform
    final bool isWeb = kIsWeb;

    return WillPopScope(
      onWillPop: () async {
        // Prevent navigating back to the previous screen
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Manager Dashboard",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.grey[300],
          automaticallyImplyLeading: false, // Remove back navigation arrow
          actions: [
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 35, // Increase the size of the icon
                color: Colors.black,
              ),
              onSelected: (value) {
                if (value == 'profile') {
                  // Handle profile option
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerProfile(),
                    ),
                  );
                } else if (value == 'logout') {
                  // Handle logout option
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => login(),
                    ),
                  );
                } else if(value == 'history'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillHistoryScreen(),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 30, // Increase the size of the icon
                      ),
                      SizedBox(width: 15), // Increase the spacing between icon and text
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20, // Increase the size of the text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30, // Increase the size of the icon
                      ),
                      SizedBox(width: 15), // Increase the spacing between icon and text
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20, // Increase the size of the text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        color: Colors.green,
                        size: 30, // Increase the size of the icon
                      ),
                      SizedBox(width: 15), // Increase the spacing between icon and text
                      Text(
                        'Bill History',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20, // Increase the size of the text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: isWeb
            ? Row(
          children: [
            NavigationRail(
              backgroundColor: Colors.grey[300],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 10), // Add padding for space
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 10), // Add padding for space
                  icon: Icon(Icons.restaurant_menu),
                  label: Text('Menu Item'),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 10), // Add padding for space
                  icon: Icon(Icons.people),
                  label: Text('Staff'),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 10), // Add padding for space
                  icon: Icon(Icons.receipt_long),
                  label: Text('Bill'),
                ),
              ],
              selectedIconTheme: const IconThemeData(
                color: Colors.black, // Set selected icon color to white
              ),
              selectedLabelTextStyle: TextStyle(
                color: Colors.black, // Set selected label color to white
                fontWeight: FontWeight.bold,
              ),
            ),
            VerticalDivider(thickness: 2, width: 2, color:Colors.black,),
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        )

            : _screens[_selectedIndex],
        bottomNavigationBar: isWeb
            ? null // Hide bottom navigation bar on web
            : Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                // Add a border on the top
                color: Colors.black, // Set border color
                width: 0.5, // Set border width
              ),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.grey[300],
            type: BottomNavigationBarType.fixed, // Needed for more than 3 items
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black, // Set icon color to white
            unselectedItemColor: Colors.black, // Set label color to black
            selectedFontSize: 15,
            selectedIconTheme: const IconThemeData(
              size: 33,
            ),
            selectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            iconSize: 24,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Menu Item',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Staff',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Bill',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set scaffold background to grey
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([
                FirebaseFirestore.instance.collection('Item').get(),
                FirebaseFirestore.instance.collection('Staff').get(),
              ]),
              builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  );
                }

                int? numberOfItems = snapshot.data![0].docs.length;
                int? numberOfStaff = snapshot.data![1].docs.length;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      // For mobile devices, return a column layout
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height:20,),
                          SizedBox(
                            height: 60,
                            width: 350, // Set the desired width of the containers
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900], // Set text background color to black
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  "Total Number of Items Available: $numberOfItems",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 60,
                            width: 350, // Set the same width for consistency
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900], // Set text background color to black
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  "Total Number of Staff Available: $numberOfStaff",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // For web or larger screens, return a row layout
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height:125),
                          SizedBox(
                            height: 60,
                            width: 350,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  "Total Number of Items Available: $numberOfItems",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 60,
                            width: 350,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  "Total Number of Staff Available: $numberOfStaff",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
