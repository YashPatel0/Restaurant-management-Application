import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/manager/manager_dashboard.dart';
import 'manager_signup.dart';

class ManagerLoginPage extends StatelessWidget {
  final TextEditingController managerUsernameController =
  TextEditingController();
  final TextEditingController managerPasswordController =
  TextEditingController();

  ManagerLoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Manager Login",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100,),
                Icon(
                  Icons.lock,
                  size: 120,
                ),
                SizedBox(height: 10,),
                // Text Field for Manager E-mail
            SizedBox(
              width: kIsWeb ? screenWidth * 0.3 : double.infinity,
              child:
              TextField(
                  controller: managerUsernameController,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter Manager E-mail',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),),
                SizedBox(height: 20),
                // Text Field for Manager Password
            SizedBox(
              width: kIsWeb ? screenWidth * 0.3 : double.infinity,
              child: TextField(
                  controller: managerPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter Manager Password',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),),
                SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: kIsWeb ? screenWidth * 0.3 : double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String enteredEmail =
                      managerUsernameController.text.trim();
                      String enteredPassword =
                      managerPasswordController.text.trim();

                      FirebaseFirestore.instance
                          .collection('Manager')
                          .where('email', isEqualTo: enteredEmail)
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isNotEmpty) {
                          // If email exists, attempt login
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: enteredEmail,
                            password: enteredPassword,
                          )
                              .then((userCredential) {
                            // If login is successful
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManagerDashboard()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 10),
                                    Text('Login Successful!'),
                                  ],
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }).catchError((error) {
                            // If login fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Invalid Login. Please check your email and password.'),
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          });
                        } else {
                          // If email does not exist
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Email not found. Please sign up as a manager.'),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                        }
                      });
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.grey[900],
                    ),
                  ),
                ),
                SizedBox(height: 30), // Add space between the button and the text
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpManager()),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Click here',
                    style: TextStyle(
                      color:Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
