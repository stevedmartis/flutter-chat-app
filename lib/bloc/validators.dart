import 'dart:async';

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email no es correcto');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 1) {
      sink.add(password);
    } else {
      sink.addError('Password is required');
    }
  });

  final validationNameRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Name is required');
    }
  });

  final validationUserNameRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length >= 1) {
      sink.add(text);
    } else {
      sink.addError('Username is required');
    }
  });
}

final validationOk =
    StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
  if (text.length > 1) {
    sink.add(text);
  } else {
    // sink.addError('Ingrese requerido');
  }
});
