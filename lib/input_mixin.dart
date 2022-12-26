mixin InputValidationMixin {
  bool isNameValid(String name) {

    if(name.length==0){
return false;
    }
    return true;

  } 

    bool isLastNameValid(String lastname) {

    if(lastname.length==0){
return false;
    }
    return true;

  } 


  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0|| value.length>10) {
          return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
}


  bool isEmailValid(String email) {
      if (email.length == 0) {
          return false;
    }
    Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}