import 'package:contact_list_app/db_helper/db_repository.dart';
import 'package:contact_list_app/model/contact_model.dart';

class ContactService {
  late Repository _repository;
  ContactService() {
    _repository = Repository();
  }

  saveContact(UserContact user) async {
    return await _repository.insertData(
        'contactListTable', user.contactUserToMap());
  }

  readAllContact() async {
    return await _repository.readData('contactListTable');
  }

  updateContact(UserContact user) async {
    return await _repository.updateData(
        'contactListTable', user.contactUserToMap());
  }

  deleteContact(userId) async {
    return await _repository.deleteDataById('contactListTable', userId);
  }

  saveLoginData(LogUser data) async {
    return await _repository.insertLoginData(
        'signupDataTable', data.logUserToMap());
  }

  searchEmailandPassword(String email, String pass) async {
    return await _repository.searchByEmail('signupDataTable', email, pass);
  }

  checkMailExistence(String email) async {
    return await _repository.checkMailExist('signupDataTable', email);
  }
}
