import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemEntryScreen extends StatelessWidget {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter Menu",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Item Name:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
          SizedBox(
            width: kIsWeb ? screenWidth * 0.3 : double.infinity,
            child: TextField(
                controller: _itemNameController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Item Name',
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
          ),
              SizedBox(height: 20),
              const Text(
                'Enter Item Price:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
          SizedBox(
            width: kIsWeb ? screenWidth * 0.3 : double.infinity,
            child:TextField(
                controller: _priceController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Enter Price',
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
              ),),
              SizedBox(height: 20),
              SizedBox(
                width: kIsWeb ? screenWidth * 0.3 : double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String itemName = _itemNameController.text;
                    String price = _priceController.text;
                    if (itemName.isNotEmpty && price.isNotEmpty) {
                      // Store data in Firebase Firestore
                      FirebaseFirestore.instance.collection('Item').add({
                        'itemName': itemName,
                        'price': double.parse(price),
                      }).then((_) {
                        Navigator.pop(context); // Close the screen after data is stored
                      }).catchError((error) {
                        // Handle errors if any
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add item: $error'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter both item name and price.'),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Enter Item",
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
            ],
          ),
        ),
      ),
    );
  }
}
