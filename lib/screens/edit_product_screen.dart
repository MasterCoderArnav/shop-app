import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import '../provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final focusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final imageURLController = TextEditingController();
  final imageURLFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var editedProduct =
      Product(description: '', title: '', imageURL: '', price: 0, id: '');
  var _isLoading = false;
  var _isInit = true;

  var initValues = {
    'id': '',
    'title': '',
    'imageURL': '',
    'price': 0,
    'description': '',
    'isFavourite': false,
  };

  @override
  void initState() {
    imageURLFocusNode.addListener(updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context)!.settings.arguments as String?;
      if (productID != null) {
        final product =
            Provider.of<Products>(context, listen: false).findByID(productID);
        editedProduct = product;
        initValues['id'] = editedProduct.id;
        initValues['description'] = editedProduct.description;
        initValues['title'] = editedProduct.title;
        initValues['price'] = editedProduct.price;
        initValues['imageURL'] = '';
        initValues['isFavourite'] = editedProduct.isFavourite;
        imageURLController.text = product.imageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImageURL() {
    if (!imageURLFocusNode.hasFocus) {
      setState(() {});
    } else {}
  }

  @override
  void dispose() {
    imageURLFocusNode.removeListener(updateImageURL);
    imageURLController.dispose();
    focusNode.dispose();
    _descriptionFocusNode.dispose();
    imageURLFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return Future.value();
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final item = Provider.of<Products>(context, listen: false);
    final prod = item.items.indexWhere((elem) => elem.id == editedProduct.id);
    if (prod == -1) {
      item.addProduct(editedProduct).catchError((error) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      try {
        await item.updateProduct(editedProduct);
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'] as String,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Title',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        onSaved: (value) {
                          if (value != null) {
                            editedProduct = Product(
                              description: editedProduct.description,
                              title: value,
                              imageURL: editedProduct.imageURL,
                              price: editedProduct.price,
                              id: editedProduct.id,
                            );
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          }
                          return 'Please enter a valid value';
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'].toString(),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Please enter a price';
                            } else if (double.tryParse(value) == null) {
                              return 'Enter a valid price';
                            }
                            return null;
                          }
                          return 'Please enter a price';
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Price',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.0,
                            ),
                          ),
                        ),
                        focusNode: focusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          if (value != null) {
                            editedProduct = Product(
                              description: editedProduct.description,
                              title: editedProduct.title,
                              imageURL: editedProduct.imageURL,
                              price: double.parse(value),
                              id: editedProduct.id,
                            );
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'] as String,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter description',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.0,
                            ),
                          ),
                        ),
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          if (value != null) {
                            editedProduct = Product(
                              description: value,
                              title: editedProduct.title,
                              imageURL: editedProduct.imageURL,
                              price: editedProduct.price,
                              id: editedProduct.id,
                            );
                          }
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(imageURLFocusNode);
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Please enter the description of the product';
                            }
                            return null;
                          }
                          return 'Please enter the description of the product';
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 10, top: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: Container(
                              child: imageURLController.text.isEmpty
                                  ? const Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        imageURLController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: imageURLController,
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Image URL',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.pink,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              focusNode: imageURLFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              // onFieldSubmitted: (_) {
                              //   saveForm();
                              // },
                              onSaved: (value) {
                                if (value != null) {
                                  editedProduct = Product(
                                    description: editedProduct.description,
                                    title: editedProduct.title,
                                    imageURL: value,
                                    price: editedProduct.price,
                                    id: editedProduct.id,
                                  );
                                }
                              },
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Enter a valid url';
                                  } else if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Enter a valid url';
                                  } else if (!value.endsWith('.jpeg') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.png')) {
                                    return 'Enter a valid url for an image';
                                  }
                                  return null;
                                }
                                return 'Enter a valid url';
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveForm();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
//https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Empty_book.jpg/640px-Empty_book.jpg