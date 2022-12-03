import 'dart:io';
import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/service/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditContact extends StatefulWidget {
  final UserContact user;
  const EditContact({Key? key, required this.user}) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _userNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userEmailController = TextEditingController();

  bool _validateImage = false;
  bool _validateName = false;
  bool _validatePhone = false;
  bool _validateEmail = false;

  final _contactService = ContactService();

  @override
  void initState() {
    setState(() {
      _userNameController.text = widget.user.name ?? '';
      _userPhoneController.text = widget.user.phone ?? '';
      _userEmailController.text = widget.user.email ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact Info"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Contact Info',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: widget.user.image != null
                            ? FileImage(File(widget.user.image!))
                            : const AssetImage('images/avatar.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () async {
                  try {
                    await ImagePicker()
                        .pickImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file == null) return;
                      setState(() {
                        widget.user.image = file.path;
                      });
                    });
                  } catch (error) {
                    //print("error: $error");
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    errorText: _validateName
                        ? 'Name Value Can\'t Be Empty or Invalid'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userPhoneController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Phone',
                    labelText: 'Phone',
                    errorText: _validatePhone
                        ? 'Phone Value Can\'t Be Empty or Invalid'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userEmailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Eamil',
                    errorText: _validateEmail
                        ? 'Email Value Can\'t Be Empty or Invalid'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          widget.user.image == null
                              ? _validateImage = true
                              : _validateImage = false;

                          _userNameController.text.isEmpty
                              ? _validateName = true
                              : RegExp(r'^[a-z A-Z]+$')
                                      .hasMatch(_userNameController.text)
                                  ? _validateName = false
                                  : _validateName = true;

                          _userPhoneController.text.isEmpty
                              ? _validatePhone = true
                              : RegExp(r'^(?:\+?88)?01[13-9]\d{8}$')
                                      .hasMatch(_userPhoneController.text)
                                  ? _validatePhone = false
                                  : _validatePhone = true;

                          _userEmailController.text.isEmpty
                              ? _validateEmail = true
                              : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                      .hasMatch(_userEmailController.text)
                                  ? _validateEmail = false
                                  : _validateEmail = true;
                        });

                        if (_validateImage == false &&
                            _validateName == false &&
                            _validatePhone == false &&
                            _validateEmail == false) {
                          var _user = UserContact();
                          _user.id = widget.user.id;
                          _user.image = widget.user.image;
                          _user.name = _userNameController.text;
                          _user.phone = _userPhoneController.text;
                          _user.email = _userEmailController.text;
                          var result =
                              await _contactService.updateContact(_user);
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text('Update Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _userNameController.text = '';
                        _userPhoneController.text = '';
                        _userEmailController.text = '';
                      },
                      child: const Text('Clear Details'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
