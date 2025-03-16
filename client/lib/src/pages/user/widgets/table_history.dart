import 'package:client/src/models/user.dart';
import 'package:client/src/pages/user/logic/userLogic.dart';
import 'package:flutter/material.dart';
import 'package:client/src/models/history.dart';
import 'package:intl/intl.dart';

class HistoryTable extends StatefulWidget {
  final List<History> tableData;

  const HistoryTable({super.key, required this.tableData});

  @override
  _HistoryTableState createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {
  late List<History> _tableData;

  @override
  void initState() {
    super.initState();
    _tableData = List.from(widget.tableData); // Create a copy of the table data
  }

  // Function to handle delete action
  void _deleteItem(String id) async {
    bool success = await UserLogic.deleteHistory(id);
    if (success) {
      if (mounted) {
        setState(() {
          _tableData.removeWhere((data) => data.id.toString() == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully deleted item with id: $id'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete item with id: $id'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tableData.isEmpty) {
      return const Center(
        child: Text('No history data available.', style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.85,
      color: const Color.fromARGB(255, 36, 36, 36),
      child: Column(
        children: [
          // Header row remains static
          Container(
            color: const Color.fromARGB(255, 80, 80, 80),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  SizedBox(width: 10), // Add space between columns
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('Date Created', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10), // Add space between columns
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Scrollable body section for data rows
          Expanded(
            child: Scrollbar(
              trackVisibility: true,
              thickness: 6.0,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: _tableData.map((data) {
                    return Container(
                      key: ValueKey(data.id), // Ensure each row has a unique key
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Color.fromRGBO(36, 36, 36, 1)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(data.type, style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 10), // Add space between columns
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(DateFormat('yyyy-MM-dd').format(data.date), style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 10), // Add space between columns
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _deleteItem(data.id.toString()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // Button color for delete
                                  ),
                                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}