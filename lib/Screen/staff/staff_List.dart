import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'enter_staff_list.dart';

class StaffList extends StatefulWidget {
  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back navigation arrow
        title: const Text(
          "Staff List",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Staff').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              final staff = snapshot.data?.docs[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${staff?['name']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Age: ${staff?['age']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Phone: ${staff?['phone']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Adhar Card: ${staff?['adhar']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Address: ${staff?['address']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Salary: ${staff?['salary']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${staff?['email']}', // Fetch email data
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever,
                              size: 25,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _deleteItem(staff!.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StaffEntryScreen()),
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _deleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to permanently remove this staff member?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Delete the item from Firestore
                  await FirebaseFirestore.instance.collection('Staff').doc(itemId).delete();

                  // Show success message
                } catch (error) {
                  // Handle errors
                  print('Error deleting item: $error');
                } finally {
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
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
    final TextEditingController _salaryController =
        TextEditingController(text: item['salary'].toString());
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
                  SizedBox(height: 20),
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
                    controller: _salaryController,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Salary',
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
                      border: Border.all(color: Colors.black,width:2.5), // Set border color to black
                      borderRadius: BorderRadius.circular(5), // You can adjust the border radius as needed
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
                        border: InputBorder.none, // Hide the default border of TextField
                        contentPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust padding as needed
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
                            'salary': double.parse(_salaryController.text),
                            'adhar': int.parse(_adharController.text),
                            'email': _emailController.text, // Update email
                          }).then((_) {
                            Navigator.pop(context); // Close the modal sheet
                          }).catchError((error) {
                            // Handle errors if any
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update item: $error'),
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
                        color: Colors.black, // Adjust the text color as needed
                      ),
                    ),
                        TextButton(
                          onPressed: () {
                            _changePassword(_emailController.text);
                          },
                          child: Text(
                            'Click Here!',
                            style: TextStyle(
                              fontSize:20,
                              color: Colors.black, // Adjust the text color as needed
                              decoration: TextDecoration.underline, // Add underline decoration

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

  void _changePassword(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      _showPopMessage('Password reset link sent to $email');
    }).catchError((error) {
      _showPopMessage('Failed to send password reset link: $error');
    });
  }

  void _showPopMessage(String message) {
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
