import 'package:flutter/material.dart';
import 'package:shop/model/product.dart';

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

  @override
  void initState() {
    imageURLFocusNode.addListener(updateImageURL);
    super.initState();
  }

  void updateImageURL() {
    if (!imageURLFocusNode.hasFocus) {
      setState(() {});
    } else {}
  }

  @override
  void dispose() {
    imageURLFocusNode.removeListener(updateImageURL);
    focusNode.dispose();
    _descriptionFocusNode.dispose();
    imageURLController.dispose();
    imageURLFocusNode.dispose();
    super.dispose();
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    print(editedProduct.title);
    print(editedProduct.description);
    print(editedProduct.price);
    print(editedProduct.imageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
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
                  },
                ),
                TextFormField(
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
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'Please enter the description of the product';
                      }
                      return null;
                    }
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
                        onFieldSubmitted: (_) {
                          saveForm();
                        },
                        onSaved: (value) {
                          if (value != null) {
                            editedProduct = Product(
                              description: editedProduct.description,
                              title: value,
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
                            }
                            return null;
                          }
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
