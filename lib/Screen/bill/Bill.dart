import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Bill extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back navigation arrow
        backgroundColor: Colors.grey[300],
        title: Text(
          'Bill',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Bill').snapshots(),
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
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Group data by table number
            var groupedData = <int, List<Map<String, dynamic>>>{};
            snapshot.data!.docs.forEach((doc) {
              var tableNumber = doc['tableNumber'];
              if (!groupedData.containsKey(tableNumber)) {
                groupedData[tableNumber] = [];
              }
              groupedData[tableNumber]!.add({
                'id': doc.id, // Add document ID
                'itemName': doc['itemName'],
                'price': doc['price'],
                'plates': doc['plates'],
                'totalPrice': doc['totalPrice'], // Assuming you have a 'totalPrice' field in your document
                'dateTime': doc['dateTime'], // Add datetime from Firestore
              });
            });

            // Create cards for each table
            var tableCards = groupedData.entries.map((entry) {
              var tableNumber = entry.key;
              var items = entry.value.map((item) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item: ${item['itemName']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Price: ${item['price']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Number of Plates: ${item['plates']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: ${item['totalPrice']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();

              items.add(
                ListTile(
                  title: Divider(
                    color: Colors.black,
                    thickness: 2,
                    height: 10, // Adjust the height as needed
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
              );

              String formattedDateTime = DateFormat('dd-MM-yyyy  &  hh:mm:ss a ').format((entry.value.first['dateTime'] as Timestamp).toDate());

              // Calculate the total amount for the table
              var totalAmount = entry.value.fold(
                  0.0, (sum, item) => sum + (item['totalPrice'] as num).toDouble());

              // Add the total amount to the bottom of the card
              items.add(
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Align items to start and end of the row
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 15), // Add a SizedBox for spacing
                      Text(
                        'Rs.$totalAmount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );

              // Add the "Amount Paid" button
              items.add(
                ListTile(
                  title: kIsWeb ? // Check if it's web
                  FractionallySizedBox(
                    widthFactor: 0.4, // Set button width to 40% of the screen width
                    child: ElevatedButton(
                      onPressed: () {
                        // Show pop-up indicating payment confirmation
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Payment Confirmation"),
                              content:
                              Text("Payment for Table $tableNumber has been done."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Delete items for the table from Firestore
                                    entry.value.forEach((item) {
                                      FirebaseFirestore.instance
                                          .collection('Bill')
                                          .doc(item['id'])
                                          .delete();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Amount Paid",
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Set button color to black
                      ),
                    ),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      // Show pop-up indicating payment confirmation
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Payment Confirmation"),
                            content:
                            Text("Payment for Table $tableNumber has been done."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Delete items for the table from Firestore
                                  entry.value.forEach((item) {
                                    FirebaseFirestore.instance
                                        .collection('Bill')
                                        .doc(item['id'])
                                        .delete();
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Amount Paid",
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Set button color to black
                    ),
                  ),
                ),
              );

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:20.0),
                child: Card(
                  color: Colors.grey[300],
                  elevation: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Table $tableNumber Bill',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: Text(
                                'Date & Time: $formattedDateTime',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: items,
                      ),
                    ],
                  ),
                ),
              );
            }).toList();

            // Return the list of table cards
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: tableCards,
              ),
            );
          }
          // If there's no data
          return Center(
            child: Text('No Bill available'),
          );
        },
      ),
    );
  }
}
