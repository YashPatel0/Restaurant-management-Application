import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/foundation.dart' show kIsWeb;

class StaffEntryScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _adharController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter Staff Details",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFormField for full name
              SizedBox(
              width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child:
                TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    },
                  ),
              ),
                  SizedBox(height: 20),
                  // TextFormField for email
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for password
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    obscureText: true, // Hide the entered password
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for phone number
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Phone number must contain only digits (0-9)';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for address
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _addressController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for age
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _ageController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Age';
                      } else if (value.length < 0) {
                        return 'Age must be 2 digits';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Age must contain only digits (0-9)';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 2,
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for Adhar card number
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _adharController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Adhar Card Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Adhar Card Number';
                      } else if (value.length != 12) {
                        return 'Adhar Card Number must be 12 digits';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Adhar Card Number must contain only digits (0-9)';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 12,
                  ),),
                  SizedBox(height: 20),
                  // TextFormField for salary
              SizedBox(
                width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                child: TextFormField(
                    controller: _salaryController,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter Salary',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter salary';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),),
                  SizedBox(height: 20),
                  SizedBox(
                    width: kIsWeb ? screenWidth * 0.4 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Retrieve entered data and pass it back to the previous screen
                        String name = _nameController.text;
                        int? age = int.tryParse(_ageController.text);
                        int? phone = int.tryParse(_phoneController.text);
                        String address = _addressController.text;
                        double? salary = double.tryParse(_salaryController.text);
                        int? adhar = int.tryParse(_adharController.text);
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        // Validate that all fields are filled
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, proceed with sign up
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          )
                              .then((userCredential) {
                            // Once user is signed up, store additional details in Firestore
                            String uid = userCredential.user!.uid;
                            FirebaseFirestore.instance
                                .collection('Staff')
                                .doc(uid)
                                .set({
                              'name': name,
                              'age': age,
                              'phone': phone,
                              'address': address,
                              'salary': salary,
                              'adhar': adhar,
                              'email': email,
                            }).then((value) {
                              // Navigate back to previous screen after storing data
                              Navigator.pop(context);
                            }).catchError((error) {
                              // Handle Firestore errors
                              print("Failed to add user details: $error");
                            });
                          }).catchError((error) {
                            // Handle FirebaseAuth errors
                            print("Failed to create user: $error");
                          });
                        }
                      },
                      child: Text(
                        "Enter Details",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.black,
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
