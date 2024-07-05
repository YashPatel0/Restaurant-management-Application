import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_system/Screen/item ordered/order.dart';

class ItemList extends StatefulWidget {
  final int tableNumber;

  ItemList({required this.tableNumber});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  // Firestore collection reference
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('Item');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Item Lists To Order",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Set the preferred height
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Table Number: ${widget.tableNumber}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    data['itemName'],
                    style: TextStyle(fontSize: 22.0), // Set the font size
                  ),
                  subtitle: Text(
                    'Rs.${data['price']}',
                    style: TextStyle(fontSize: 19.0), // Set the font size
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Check if the item already exists in the order
                        QuerySnapshot orderSnapshot = await FirebaseFirestore
                            .instance
                            .collection('Order')
                            .where('itemName', isEqualTo: data['itemName'])
                            .where('tableNumber', isEqualTo: widget.tableNumber)
                            .get();

                        // If the item exists, update the number of plates
                        if (orderSnapshot.docs.isNotEmpty) {
                          // Get the document ID of the existing order item
                          String orderId = orderSnapshot.docs.first.id;

                          // Get the current number of plates and increment it by 1
                          int currentPlates =
                              orderSnapshot.docs.first['plates'];
                          int updatedPlates = currentPlates + 1;

                          // Update the number of plates in the order
                          await FirebaseFirestore.instance
                              .collection('Order')
                              .doc(orderId)
                              .update({'plates': updatedPlates});
                        } else {
                          // If the item does not exist, add it to the order
                          await FirebaseFirestore.instance
                              .collection('Order')
                              .add({
                            'itemName': data['itemName'],
                            'price': data['price'],
                            'tableNumber': widget.tableNumber,
                            'plates':
                                1, // Set the initial number of plates to 1
                            // Add other necessary fields if needed
                          });
                        }
                      } catch (error) {
                        // Handle errors
                        print('Error adding item to order: $error');
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.black, // Set button color to black
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderList(tableNumber: widget.tableNumber),
            ),
          );
        },
        label: Text(
          'View Order',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
