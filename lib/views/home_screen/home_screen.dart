import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_july_sample/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addItem() {}

  void _editItem(int index) {
    // _titleController.text = sampleData[index]['title'];
    // _descriptionController.text = sampleData[index]['subtitle'];
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Edit Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Edit Description'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenProvider = context.watch<HomeScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Item Description'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: homeScreenProvider.itemsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var currentItme =
                          snapshot.data!.docs[index]; // cocument item
                      return ListTile(
                        title: Text(currentItme['name']),
                        subtitle: Text(currentItme['des']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () => _editItem(index),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context
                                      .read<HomeScreenController>()
                                      .itemsCollection
                                      .doc(currentItme.id)
                                      .delete();
                                }),
                          ],
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(
                  child: Text('No data found'),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}

// ListView.builder(
//               padding: EdgeInsets.all(8.0),
//               itemCount: sampleData.length,
//               itemBuilder: (context, index) {
//                 final item = sampleData[index];
//                 return Card(
//                   elevation: 4,
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.blue[100],
//                       child: Icon(
//                         item['icon'],
//                         color: Colors.blue,
//                       ),
//                     ),
//                     title: Text(
//                       item['title'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(item['subtitle']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.green),
//                           onPressed: () => _editItem(index),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteItem(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
