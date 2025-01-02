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
  final formKey = GlobalKey<FormState>();

  void _editItem(int index,
      {String? docId, String title = '', String description = ''}) {
    _titleController.text = title;
    _descriptionController.text = description;
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
                      context.read<HomeScreenController>().updateItem(
                          id: docId.toString(),
                          title: _titleController.text,
                          description: _descriptionController.text);
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
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      context.read<HomeScreenController>().uploadImage();
                    },
                    child: CircleAvatar(
                      radius: 50,
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Item Description'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
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
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<HomeScreenController>().addItem(
                                title: _titleController.text,
                                description: _descriptionController.text);
                            _titleController.clear();
                            _descriptionController.clear();
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
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
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(currentItme['url']),
                        ),
                        title: Text(currentItme['name']),
                        subtitle: Text(currentItme['des']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () => _editItem(index,
                                  docId: currentItme.id,
                                  title: currentItme['name'],
                                  description: currentItme['des']),
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
