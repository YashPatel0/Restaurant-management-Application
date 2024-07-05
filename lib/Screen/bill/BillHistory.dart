import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillHistoryScreen extends StatefulWidget {
  @override
  _BillHistoryScreenState createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  DateTime? _selectedDate;

  Future<void> _refreshData() async {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Bill History",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: kIsWeb ? screenWidth * 0.5 : screenWidth * 0.8 ,
            child: ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Select Date',
                style: TextStyle(
                  fontSize:15,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.grey[900],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _selectedDate != null
                  ? FirebaseFirestore.instance
                  .collection('BillHistory')
                  .where('dateTime',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(
                      DateTime(_selectedDate!.year,
                          _selectedDate!.month, _selectedDate!.day)))
                  .where('dateTime',
                  isLessThan: Timestamp.fromDate(DateTime(
                      _selectedDate!.year, _selectedDate!.month,
                      _selectedDate!.day + 1)))
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection('BillHistory')
                  .orderBy('dateTime',
                  descending: true) // Sort by date/time in descending order
                  .snapshots(),
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
                      'id': doc.id,
                      'itemName': doc['itemName'],
                      'price': doc['price'],
                      'plates': doc['plates'],
                      'totalPrice': doc['totalPrice'],
                      'dateTime': doc['dateTime'],
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
                          height: 10,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                    );

                    String formattedDateTime =
                    DateFormat('dd-MM-yyyy  &  hh:mm:ss a ').format(
                        (entry.value.first['dateTime'] as Timestamp)
                            .toDate());

                    // Calculate the total amount for the table
                    var totalAmount = entry.value.fold(
                        0.0,
                            (sum, item) =>
                        sum + (item['totalPrice'] as num).toDouble());

                    // Add the total amount to the bottom of the card
                    items.add(
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Amount:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Rs.$totalAmount',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
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
          ),
        ],
      ),
    );
  }
}
