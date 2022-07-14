import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedproduct =
      Product(id: null, title: '', description: '', ImageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'ImageUrl': ''
  };

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    print(_editedproduct.ImageUrl);
    // ModalRoute.of(context).ser
    super.initState();
  }

  var _isinit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedproduct.title,
          'description': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          'ImageUrl': ''
        };
        _imageUrlController.text = _editedproduct.ImageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (_imageUrlController.text.startsWith('http') &&
        !_imageUrlController.text.startsWith('https')) {
      return;
    }
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedproduct.id != null) {
      try {
       await  Provider.of<Products>(context, listen: false)
            .updateProduct(_editedproduct.id, _editedproduct);
      } catch (error) {
        throw (error);
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedproduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text('An error occured'),
                    content: Text('Something went wrong'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ]));
        // } finally {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   Navigator.pop(context);
        // }
      }
    }

    // _form.currentState.save();

    // Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit product'), actions: <Widget>[
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save)),
        ]),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _form,
                  child: ListView(children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a value';
                        }
                        return null;
                        // return 'This is wrong';
                      },
                      onSaved: (value) {
                        _editedproduct = Product(
                            title: value,
                            price: _editedproduct.price,
                            description: _editedproduct.description,
                            ImageUrl: _editedproduct.ImageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Value should be greator than 0';
                        }
                        return null;
                        // return 'This is wrong';
                      },
                      onSaved: (value) {
                        _editedproduct = Product(
                            title: _editedproduct.title,
                            price: double.parse(value),
                            description: _editedproduct.description,
                            ImageUrl: _editedproduct.ImageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return 'Please eneter atleast 10 characters';
                        }

                        return null;
                        // return 'This is wrong';
                      },
                      onSaved: (value) {
                        _editedproduct = Product(
                            title: _editedproduct.title,
                            price: _editedproduct.price,
                            description: value,
                            ImageUrl: _editedproduct.ImageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Container(
                            child: Container(
                                child: _imageUrlController.text.isEmpty
                                    ? const Text('Enter image URL')
                                    : FittedBox(
                                        child: Image.network(
                                            _imageUrlController.text)))),
                      ), //   TextFormField(
                      //     decoration: InputDecoration(labelText: 'Image url'),
                      //     keyboardType: TextInputType.url,
                      //     textInputAction: TextInputAction.done,
                      //     controller:_imageUrlController.text.isEmpty?const Text('Enter image URL'):Image.network(_imageUrlController.text)
                      // ]),
                      Expanded(
                          child: TextFormField(
                        //  initialValue:
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter an image url';
                          }
                          if (value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'please enter a valid url';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedproduct = Product(
                            title: _editedproduct.title,
                            price: _editedproduct.price,
                            description: _editedproduct.description,
                            ImageUrl: value,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite,
                          );
                        },
                      )),
                    ])
                  ]),
                )));
  }
}
