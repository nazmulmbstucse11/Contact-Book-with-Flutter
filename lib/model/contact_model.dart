class UserContact {
  int? id;
  String? image;
  String? name;
  String? phone;
  String? email;

  UserContact({this.id, this.image, this.name, this.phone, this.email});

  contactUserToMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['image'] = image;
    mapping['name'] = name;
    mapping['phone'] = phone;
    mapping['email'] = email;
    return mapping;
  }

  UserContact.contactUserfromMap(Map<String, dynamic> mapFrom) {
    id = mapFrom['id'];
    image = mapFrom['image'];
    name = mapFrom['name'];
    phone = mapFrom['phone'];
    email = mapFrom['email'];
  }
}

class LogUser {
  int? logid;
  String? logemail;
  String? password;

  LogUser({this.logid, this.logemail, this.password});

  logUserToMap() {
    var logmap = Map<String, dynamic>();
    logmap['logid'] = logid ?? null;
    logmap['logemail'] = logemail;
    logmap['password'] = password;
    return logmap;
  }

  LogUser.logUserfromMap(Map<String, dynamic> logFrom) {
    logid = logFrom['logid'];
    logemail = logFrom['logemail'];
    password = logFrom['password'];
  }
}
