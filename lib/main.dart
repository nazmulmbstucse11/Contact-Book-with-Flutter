import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/screen/edit_contact.dart';
import 'package:contact_list_app/screen/add_contact.dart';
import 'package:contact_list_app/service/contact_service.dart';
import 'package:contact_list_app/screen/signup.dart';
import 'package:contact_list_app/screen/login.dart';
import 'package:contact_list_app/data/contact_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<UserContact> _contactList = <UserContact>[];
  late List<LogUser> _logList = <LogUser>[];
  final _contactService = ContactService();

  getAllContactDetails() async {
    var users = await _contactService.readAllContact();

    _contactList = <UserContact>[];

    users.forEach((user) {
      setState(() {
        _contactList.add(UserContact.contactUserfromMap(user));
      });
    });
  }

  getDataFromDataFile() {
    for (int i = 0; i < datacontact.length; i++) {
      _contactService.saveContact(datacontact[i]);
    }
  }

  bool loggedChk = false;

  getLogData(String strMail, String strPass) async {
    var exist = await _contactService.searchEmailandPassword(strMail, strPass);

    loggedChk = false;
    _logList = <LogUser>[];

    exist.forEach((item) {
      setState(() {
        _logList.add(LogUser.logUserfromMap(item));
      });
    });

    if (_logList.isNotEmpty) {
      loggedChk = true;
      _showSuccessSnackBar('Login Successfully');
    } else {
      _showSuccessSnackBar('Login Detail Not Exist Try With Another Or SignUp');
    }
  }

  @override
  void initState() {
    getDataFromDataFile();
    getAllContactDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  callSystem(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  messageSystem(String number) async {
    String message = "This is test message";
    List<String> recipents = [number];
    await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {});
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () {
                    var result = _contactService.deleteContact(userId);
                    if (result != null) {
                      getAllContactDetails();
                      Navigator.pop(context);
                      _showSuccessSnackBar(
                          'Contact Details Deleted Successfully');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Contact List'),
            const SizedBox(
              width: 60.0,
            ),
            if (loggedChk == false) ...[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogIn())).then((data) {
                    if (data != null) {
                      String mail = data.logemail;
                      String pass = data.password;
                      getLogData(mail, pass);
                    }
                  });
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                width: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUp())).then((data) {
                    if (data != null) {
                      _showSuccessSnackBar('SignUp Details Added Successfully');
                    }
                  });
                },
                child: const Text('Signup'),
              ),
            ] else ...[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  loggedChk = false;
                  getAllContactDetails();
                  _showSuccessSnackBar('Logout Successfully');
                },
                child: const Text('Logout'),
              ),
            ]
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: _contactList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: ExpansionTile(
                leading: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contactList[index].image != null
                            ? FileImage(File(_contactList[index].image!))
                            : const AssetImage('images/img_avatar.png')
                                as ImageProvider,
                        fit: BoxFit.cover),
                  ),
                ),
                title: Text(_contactList[index].name ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_contactList[index].phone ?? ''),
                    Text(_contactList[index].email ?? ''),
                  ],
                ),
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            callSystem(_contactList[index].phone!);
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            messageSystem(_contactList[index].phone!);
                          },
                          icon: const Icon(
                            Icons.message,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditContact(
                                          user: _contactList[index],
                                        ))).then((data) {
                              if (data != null) {
                                getAllContactDetails();
                                _showSuccessSnackBar(
                                    'Contact Details Updated Successfully');
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _deleteFormDialog(context, _contactList[index].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (loggedChk == true) ...[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddContact())).then((data) {
                  if (data != null) {
                    getAllContactDetails();
                    _showSuccessSnackBar('Contact Details Added Successfully');
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
          ]
        ],
      ),
    );
  }
}
