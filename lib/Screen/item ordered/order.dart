import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList extends StatefulWidget {
  final int tableNumber;

  OrderList({required this.tableNumber});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  // Function to generate bill
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Order List - Table ${widget.tableNumber}",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Order')
                  .where('tableNumber', isEqualTo: widget.tableNumber)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      child: ListTile(
                        title: Text(
                          data['itemName'],
                          style: TextStyle(
                            fontSize: 25, // Adjust the font size as needed
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Rs.${data['price']}',
                              style: TextStyle(
                                fontSize: 20, // Adjust the font size as needed
                              ),
                            ),
                            Text(
                              'Number of Plates: ${data['plates']}',
                              style: TextStyle(
                                fontSize: 20, // Adjust the font size as needed
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            int currentPlates = data['plates'];
                            if (currentPlates == 1) {
                              // If number of plates is 1, delete the item from Firestore
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(document.id)
                                  .delete()
                                  .then((_) {
                                // Show success message or perform any additional tasks if required
                              }).catchError((error) {
                                // Handle errors if any
                                print('Error deleting item: $error');
                              });
                            } else {
                              // Decrease the plates count by 1
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(document.id)
                                  .update({
                                'plates': currentPlates - 1,
                              }).then((_) {
                                // Show success message or perform any additional tasks if required
                              }).catchError((error) {
                                // Handle errors if any
                                print('Error updating plates count: $error');
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: generateBill,
              child: Text(
                'Generate Bill',
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
          ),
        ],
      ),
    );
  }

  void generateBill() {
    double totalBillAmount = 0; // Variable to store the total bill amount for the table
    DateTime currentTime = DateTime.now(); // Get the current date and time

    FirebaseFirestore.instance
        .collection('Order')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        double totalPrice = data['price'] * data['plates']; // Calculate total price for the item
        totalBillAmount += totalPrice; // Add the item price to the total bill amount

        // Add the order data to the Bill collection along with the total price, table number, current time, and date
        FirebaseFirestore.instance.collection('Bill').add({
          'tableNumber': widget.tableNumber, // Include the table number in the bill data
          'itemName': data['itemName'],
          'price': data['price'],
          'plates': data['plates'],
          'totalPrice': totalPrice, // Include the total price in the bill data
          'dateTime': currentTime, // Include the current date and time in the bill data
        }).then((billDocRef) {
          // If you need to associate the generated bill ID with the order, you can update the order document with the bill ID
          document.reference.update({
            'billId': billDocRef.id,
          }).catchError((error) {
            print('Error updating order with bill ID: $error');
          });
        }).catchError((error) {
          print('Error adding item to bill: $error');
        });

        // Add the bill data to the Bill History collection for record keeping
        FirebaseFirestore.instance.collection('BillHistory').add({
          'tableNumber': widget.tableNumber, // Include the table number in the bill history data
          'itemName': data['itemName'],
          'price': data['price'],
          'plates': data['plates'],
          'totalPrice': totalPrice, // Include the total price in the bill history data
          'dateTime': currentTime, // Include the current date and time in the bill history data
        }).catchError((error) {
          print('Error adding item to bill history: $error');
        });

        // Delete this order document from the Order collection
        document.reference.delete().catchError((error) {
          print('Error deleting order: $error');
        });
      });

      // Display the total bill amount for the table (optional)
      print('Total Bill Amount for Table ${widget.tableNumber}: $totalBillAmount');
    }).catchError((error) {
      print('Error retrieving orders: $error');
    });
  }
}
