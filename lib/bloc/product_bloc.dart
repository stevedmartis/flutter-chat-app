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
  final _imageUpdateCtrl = BehaviorSubject<bool>();
  final _cbdController = BehaviorSubject<String>();
  final _thcController = BehaviorSubject<String>();
  final ProductsRepository _repository = ProductsRepository();

  final BehaviorSubject<ProductsResponse> myProduts =
      BehaviorSubject<ProductsResponse>();

  final BehaviorSubject<Product> _productSelect = BehaviorSubject<Product>();

  getProducts(String uid) async {
    ProductsResponse response = await _repository.getProducts(uid);
    myProduts.sink.add(response);
  }

  getProduct(Product product) async {
    Product response = await _repository.getProduct(product.id);
    _productSelect.sink.add(response);
  }

  BehaviorSubject<ProductsResponse> get myProducts => myProduts;
  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationUserNameRequired);

  Stream<String> get tchStream => _thcController.stream;
  Stream<String> get cbdStream => _cbdController.stream;

  Stream<bool> get formValidStream =>
      Observable.combineLatest2(nameStream, descriptionStream, (e, p) => true);

  Stream<List<Product>> get products => _productsController.stream;

  Function(List<Product>) get addProducts => _productsController.sink.add;

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeThc => _thcController.sink.add;

  Function(String) get changeCbd => _cbdController.sink.add;
  BehaviorSubject<bool> get imageUpdate => _imageUpdateCtrl;

  // Obtener el último valor ingresado a los streams

  String get name => _nameController.value;
  String get description => _descriptionController.value;
  String get cbd => _cbdController.value;
  String get thc => _thcController.value;

  BehaviorSubject<Product> get productSelect => _productSelect;

  dispose() {
    myProduts.close();
    _imageUpdateCtrl.close();
    _productSelect?.close();
    _nameController?.close();
    _descriptionController?.close();
    _productsController?.close();
    _cbdController?.close();
    _thcController?.close();
  }
}

final productBloc = ProductBloc();
