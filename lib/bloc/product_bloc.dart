import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_response.dart';
import 'package:chat/repository/products_repository.dart';

import 'package:rxdart/rxdart.dart';

class ProductBloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  final _productsController = BehaviorSubject<List<Product>>();

  final ProductsRepository _repository = ProductsRepository();

  final BehaviorSubject<ProductsResponse> _subject =
      BehaviorSubject<ProductsResponse>();

  getProducts(String userId) async {
    ProductsResponse response = await _repository.getProducts(userId);
    _subject.sink.add(response);
  }

  BehaviorSubject<ProductsResponse> get subject => _subject;
  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationUserNameRequired);

  Stream<bool> get formValidStream =>
      Observable.combineLatest2(nameStream, descriptionStream, (e, p) => true);

  Stream<List<Product>> get products => _productsController.stream;

  Function(List<Product>) get addProducts => _productsController.sink.add;

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  // Obtener el último valor ingresado a los streams

  String get name => _nameController.value;
  String get description => _descriptionController.value;

  dispose() {
    _subject.close();

    _nameController?.close();
    _descriptionController?.close();
    _productsController?.close();
  }
}

final productBloc = ProductBloc();
