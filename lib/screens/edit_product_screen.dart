import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
    //print(_editedProduct.title);
    //print(_editedProduct.description);
    //print(_editedProduct.price);
    //print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                initialValue: _initValues['price'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
              ),
              TextFormField(
                initialValue: _initValues['description'],
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      description: value,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  if (value.length < 10) {
                    return 'Description should be at least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Enter a URL'))
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                      setState(() {});
                    },
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          imageUrl: value,
                          description: _editedProduct.description,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid url';
                      }
                      if (!value.endsWith('jpeg') &&
                          !value.endsWith('png') &&
                          !value.endsWith('jpg')) {
                        return 'Please enter a valid image';
                      }

                      return null;
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
