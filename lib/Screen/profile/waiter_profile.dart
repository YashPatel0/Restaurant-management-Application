import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaiterProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    double widthFactor = MediaQuery.of(context).size.width < 600 ? 0.9 : 0.5;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Staff')
              .where('email', isEqualTo: currentUserEmail)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // or any loading indicator
            }

            // Check if there are any documents
            if (snapshot.data?.docs.isEmpty ?? true) {
              return Text('No manager data found');
            }

            final StaffData = snapshot.data!.docs.first.data()
                as Map<String, dynamic>?; // Cast to nullable Map

            if (StaffData == null) {
              return Text('Manager data is null');
            }
            DocumentSnapshot?item; // Define item as a DocumentSnapshot or nullable

            // Inside your StreamBuilder builder method or any other appropriate location
            item = snapshot.data!.docs.first; // Assuming you're retrieving the first document snapshot

            return Column(
              children: [
                Expanded(
                  child: _buildProfile(StaffData , widthFactor),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: kIsWeb ? screenWidth * 0.5 : double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button functionality here
                      _editStaff(context, item!);
                    },
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.black,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfile(Map<String, dynamic> StaffData , double widthFactor) {
    final name = StaffData['name'] ?? 'N/A';
    final phoneNumber = StaffData['phone'] ?? 'N/A';
    final address = StaffData['address'] ?? 'N/A';
    final aadharNumber = StaffData['adhar'] ?? 'N/A';
    final age = StaffData['age'] ?? 'N/A';
    final email = StaffData['email'] ?? 'N/A';
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: widthFactor, // Adjust the width factor as needed
          child: Card(
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$name",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Phone Number: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$phoneNumber",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Address: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$address",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Aadhar Number: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$aadharNumber",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Age: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$age",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "E-mail Address: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$email",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editStaff(BuildContext context, DocumentSnapshot item) {
    final TextEditingController _nameController =
        TextEditingController(text: item['name']);
    final TextEditingController _ageController =
        TextEditingController(text: item['age'].toString());
    final TextEditingController _phoneController =
        TextEditingController(text: item['phone'].toString());
    final TextEditingController _addressController =
        TextEditingController(text: item['address']);
    final TextEditingController _adharController =
        TextEditingController(text: item['adhar'].toString());
    final TextEditingController _emailController =
        TextEditingController(text: item['email']); // Fetch email data
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for full screen
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Adjust the height factor as needed
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
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
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Age',
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
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Phone',
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
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _addressController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address',
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
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _adharController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Adhar Card',
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
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          width: 2.5), // Set border color to black
                      borderRadius: BorderRadius.circular(
                          5), // You can adjust the border radius as needed
                    ),
                    child: TextField(
                      controller: _emailController,
                      enabled: false, // Make the email field non-editable
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: null, // Allow unlimited lines vertically
                      decoration: InputDecoration(
                        border: InputBorder
                            .none, // Hide the default border of TextField
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10), // Adjust padding as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Update the item in Firebase Firestore
                          FirebaseFirestore.instance
                              .collection('Staff')
                              .doc(item.id)
                              .update({
                            'name': _nameController.text,
                            'age': int.parse(_ageController.text),
                            'phone': int.parse(_phoneController.text),
                            'address': _addressController.text,
                            'adhar': int.parse(_adharController.text),
                            'email': _emailController.text, // Update email
                          }).then((_) {
                            Navigator.pop(context); // Close the modal sheet
                          }).catchError((error) {
                            // Handle errors if any
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update Staff: $error'),
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          });
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Close the modal sheet without saving changes
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To Change Password',
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                Colors.black, // Adjust the text color as needed
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _changePassword(context, _emailController.text);
                          },
                          child: Text(
                            'Click Here!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors
                                  .black, // Adjust the text color as needed
                              decoration: TextDecoration
                                  .underline, // Add underline decoration
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _changePassword(BuildContext context, String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      _showPopMessage(context, 'Password reset link sent to $email');
    }).catchError((error) {
      _showPopMessage(context, 'Failed to send password reset link: $error');
    });
  }

  void _showPopMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Reset"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
