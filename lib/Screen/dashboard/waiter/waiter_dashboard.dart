import 'package:flutter/material.dart';

import '../../item ordered/itemlist.dart';
import '../../login/login.dart';
import '../../profile/waiter_profile.dart';

class WaiterDashboard extends StatefulWidget {
  @override
  _WaiterDashboardState createState() => _WaiterDashboardState();
}

class _WaiterDashboardState extends State<WaiterDashboard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns based on screen width
    int crossAxisCount = screenWidth > 600 ? (screenWidth > 1200 ? 5 : 3) : 2;

    return WillPopScope(
      onWillPop: () async {
        // Prevent navigating back to the previous screen
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            "Waiter Dashboard",
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
                      builder: (context) => WaiterProfile(),
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
                      SizedBox(
                          width:
                          15), // Increase the spacing between icon and text
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
                      SizedBox(
                          width:
                          15), // Increase the spacing between icon and text
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
              ],
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: crossAxisCount, // Number of columns
          children: List.generate(10, (index) {
            return InkWell(
              onTap: () {
                // Handle tap on the table icon to open the second screen
                _openTableScreen(index + 1); // Index starts from 0, so add 1
              },
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20), // Set border radius
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_restaurant_rounded, // Use table icon
                        size: 50, // Adjust icon size as needed
                        color: Colors.white,
                      ),
                      SizedBox(height: 8), // Add spacing between icon and text
                      Text(
                        'Table ${index + 1}', // Display table number
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _openTableScreen(int tableNumber) {
    // Handle opening the second screen for the selected table
    // You can navigate to another screen and pass the table number if needed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemList(tableNumber: tableNumber),
      ),
    );
  }
}
