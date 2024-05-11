// validates password typed in

String? validatePassword(String? pass) {
  return (pass != '' && pass != null) ? null : 'Enter a valid password';
}

// validates inout text
String? validateText(String? pass, String errorValue) {
  return (pass != '' && pass != null) ? null : errorValue;
}


bool isNumeric(String s) {
 return double.tryParse(s) != null;
}
