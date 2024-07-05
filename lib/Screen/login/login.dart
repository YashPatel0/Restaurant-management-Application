import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'Waiter_login.dart';
import 'manager_login.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Exit the app if the back button is pressed
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            "Patel Restaurant",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic, // Change font style
            ),
          ),
          backgroundColor: Colors.grey[300],
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    height: 400,
                    width: 400,
                  ),
                  SizedBox(
                    width: kIsWeb ? screenWidth * 0.3 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigate to ManagerLoginPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerLoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Manager Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.grey[900],
                      ),
                    ),
                  ),
                  SizedBox(height: 25), // Add spacing between buttons
                  SizedBox(
                    width: kIsWeb ? screenWidth * 0.3 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigate to WaiterLoginPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaiterLoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.grey[900],
                      ),
                      child: const Text(
                        "Waiter Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
