import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/service/contact_service.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  final _contactService = ContactService();
  final _user = LogUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add SignUp Data"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add SignUp Data',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userEmailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    errorText: _validateEmail
                        ? 'Email Value Can\'t Be Empty or Invalid'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userPasswordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    errorText: _validatePassword
                        ? 'Password Value Can\'t Be Empty or Invalid'
                        : null,
                  )),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _userEmailController.text.isEmpty
                              ? _validateEmail = true
                              : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                      .hasMatch(_userEmailController.text)
                                  ? _validateEmail = false
                                  : _validateEmail = true;

                          _userPasswordController.text.isEmpty
                              ? _validatePassword = true
                              : RegExp(r'^[a-z A-Z 0-9]+$')
                                      .hasMatch(_userPasswordController.text)
                                  ? _validatePassword = false
                                  : _validatePassword = true;
                        });

                        if (_validateEmail == false &&
                            _validatePassword == false) {
                          _user.logemail = _userEmailController.text;
                          _user.password = _userPasswordController.text;

                          var mailChk = await _contactService
                              .checkMailExistence(_user.logemail.toString());

                          List<LogUser> logList = <LogUser>[];

                          mailChk.forEach((item) {
                            logList.add(LogUser.logUserfromMap(item));
                          });

                          if (logList.isEmpty) {
                            var result =
                                await _contactService.saveLoginData(_user);
                            Navigator.pop(context, result);
                          } else {
                            _showSuccessSnackBar(
                                'This mail already exist try with another');
                          }
                        }
                      },
                      child: const Text('Save Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _userEmailController.text = '';
                        _userPasswordController.text = '';
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
