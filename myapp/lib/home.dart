// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/CustomerModel.dart';
import 'package:myapp/databaseHelper.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  static const String path = "homepage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  var customerId;
  void toast(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: msg));
  }

  Future addUser() async {
    setState(() {});
    final customerModel = CustomerModel(
        id: Random().nextInt(100),
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text);
    await DatabaseHelper.instance.add(customerModel);
    toast(Text(
      "Successfully added",
      textAlign: TextAlign.center,
    ));
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  Future updateUser() async {
    setState(() {});
    final customerModel = CustomerModel(
        id: customerId,
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text);
    await DatabaseHelper.instance.update(customerModel);
    toast(Text(
      "Successfully updated",
      textAlign: TextAlign.center,
    ));
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("SQFLITE"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(38.0),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: InputDecoration(
                    label: Text("First name"),
                  ),
                ),
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: InputDecoration(
                    label: Text("Last name"),
                  ),
                ),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    label: Text("Email"),
                  ),
                ),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, right: 38),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: addUser, child: Text("Save"))),
                SizedBox(width: 20),
                Expanded(
                    child: ElevatedButton(
                        onPressed: updateUser, child: Text("Update"))),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
                future: DatabaseHelper.instance.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("Loading..."),
                      ],
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<CustomerModel> user = snapshot.data!;
                    return ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {},
                              title: Text("${user[index].firstName}"),
                              subtitle: Text("${user[index].email}"),
                              trailing: Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          setState(() {});
                                          await DatabaseHelper.instance
                                              .delete(user[index].id);
                                          toast(Text(
                                            "Successfully deleted",
                                            textAlign: TextAlign.center,
                                          ));
                                        },
                                        icon: Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () {
                                          _firstNameCtrl.text =
                                              user[index].firstName!;
                                          _lastNameCtrl.text =
                                              user[index].lastName!;
                                          _emailCtrl.text = user[index].email!;
                                          customerId = user[index].id;
                                        },
                                        icon: Icon(Icons.edit)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Data not found"),
                    );
                  }
                  return Text("nothing");
                }),
          ))
        ],
      ),
    );
  }
}
