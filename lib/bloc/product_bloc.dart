import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/catalogos_products_response.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_profiles_response.dart';
import 'package:chat/providers/catalogos_provider.dart';
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
  final CatalogosApiProvider _service = CatalogosApiProvider();

  final BehaviorSubject<ProductsProfilesResponse> _produtsProfiles =
      BehaviorSubject<ProductsProfilesResponse>();

  final BehaviorSubject<CatalogosProductsResponse> _catalogosProducts =
      BehaviorSubject<CatalogosProductsResponse>();

  final BehaviorSubject<CatalogosProductsResponse> _catalogosUserProducts =
      BehaviorSubject<CatalogosProductsResponse>();

  final BehaviorSubject<Product> _productSelect = BehaviorSubject<Product>();

  getProductsPrincipal(String uid) async {
    ProductsProfilesResponse response =
        await _repository.getProductsProfiles(uid);
    _produtsProfiles.sink.add(response);
  }

  getCatalogosProducts(String uid) async {
    CatalogosProductsResponse response =
        await _service.getMyCatalogosProducts(uid);
    if (!_catalogosProducts.isClosed) _catalogosProducts.sink.add(response);
  }

  getCatalogosUserProducts(String uidUser, String uid) async {
    CatalogosProductsResponse response =
        await _service.getCatalogosProductsUser(uidUser, uid);
    if (!_catalogosUserProducts.isClosed)
      _catalogosUserProducts.sink.add(response);
  }

  getProduct(Product product) async {
    Product response = await _repository.getProduct(product.id);
    _productSelect.sink.add(response);
  }

  BehaviorSubject<ProductsProfilesResponse> get produtsProfiles =>
      _produtsProfiles;

  BehaviorSubject<CatalogosProductsResponse> get catalogosProducts =>
      _catalogosProducts;

  BehaviorSubject<CatalogosProductsResponse> get catalogosProductsUser =>
      _catalogosUserProducts;
  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationUserNameRequired);

  Stream<String> get tchStream => _thcController.stream;
  Stream<String> get cbdStream => _cbdController.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(nameStream, descriptionStream, (e, p) => true);

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
    _catalogosProducts?.close();
    _produtsProfiles.close();
    _imageUpdateCtrl.close();
    _productSelect?.close();
    _nameController?.close();
    _descriptionController?.close();
    _productsController?.close();
    _cbdController?.close();
    _thcController?.close();
  }

  disposeProductsUser() {
    _catalogosUserProducts.close();
  }
}

final productBloc = ProductBloc();
