import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_system/Screen/item/enter_item_list.dart';

class EnterItemList extends StatefulWidget {
  @override
  _EnterItemListState createState() => _EnterItemListState();
}

class _EnterItemListState extends State<EnterItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Menu Item",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900], // Set the background color to red
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white, // Set the color of the icon to white
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemEntryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false, // Remove back navigation arrow
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Item').snapshots(),
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
                    final item = snapshot.data?.docs[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      color: Colors.grey[300],
                      child: ListTile(
                        onTap: () {
                          _editItem(context, item!); // Open modal sheet for editing
                        },
                        title: Text(
                          item?['itemName'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Rs.${item?['price']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _deleteItem(item!.id); // Pass document ID for deletion
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Store context in a variable
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to permanently remove this Item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Delete the item from Firestore
                  await FirebaseFirestore.instance.collection('Item').doc(itemId).delete();

                  // Show success message
                } catch (error) {
                  // Handle errors
                  print('Error deleting item: $error');
                } finally {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(BuildContext context, DocumentSnapshot item) {
    final TextEditingController _itemNameController =
    TextEditingController(text: item['itemName']);
    final TextEditingController _priceController =
    TextEditingController(text: item['price'].toString());

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _itemNameController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter Item Name',
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
                  controller: _priceController,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
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
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Update the item in Firebase Firestore
                        FirebaseFirestore.instance
                            .collection('Item')
                            .doc(item.id)
                            .update({
                          'itemName': _itemNameController.text,
                          'price': double.parse(_priceController.text),
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
                        Navigator.pop(context); // Close the modal sheet without saving changes
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
              ],
            ),
          ),
        );
      },
    );
  }
}
