import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gizmoglobe_client/objects/customer.dart';

import '../../../../widgets/general/gradient_icon_button.dart';
import '../../../../widgets/general/gradient_text.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  late String customerName;
  late String email;
  late String phoneNumber;
  bool _isFormDirty = false;

  @override
  void initState() {
    super.initState();
    customerName = widget.customer.customerName;
    email = widget.customer.email;
    phoneNumber = widget.customer.phoneNumber;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  Future<bool> _onWillPop() async {
    if (!_isFormDirty) return true;

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DISCARD'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: GradientText(text: 'Edit Customer'),
          elevation: 2,
          automaticallyImplyLeading: false,
          leading: GradientIconButton(
            icon: Icons.chevron_left,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              onChanged: () => setState(() => _isFormDirty = true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: TextFormField(
                              focusNode: _nameFocusNode,
                              initialValue: customerName,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: const TextStyle(color: Colors.white),
                                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                                  (states) => TextStyle(
                                    color: states.contains(MaterialState.focused) 
                                      ? Theme.of(context).primaryColor 
                                      : Colors.white,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.person, color: Colors.white,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => setState(() {
                                customerName = value;
                                _isFormDirty = true;
                              }),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: TextFormField(
                              focusNode: _emailFocusNode,
                              initialValue: email,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: const TextStyle(color: Colors.white),
                                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                                  (states) => TextStyle(
                                    color: states.contains(MaterialState.focused) 
                                      ? Theme.of(context).primaryColor 
                                      : Colors.white,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.email, color: Colors.white,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => setState(() {
                                email = value;
                                _isFormDirty = true;
                              }),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!isValidEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          TextFormField(
                            focusNode: _phoneFocusNode,
                            initialValue: phoneNumber,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(color: Colors.white),
                              floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                                (states) => TextStyle(
                                  color: states.contains(MaterialState.focused) 
                                    ? Theme.of(context).primaryColor 
                                    : Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.phone, color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: '+84 xxx xxx xxx',
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d\s+-]')),
                            ],
                            onChanged: (value) => setState(() {
                              phoneNumber = value;
                              _isFormDirty = true;
                            }),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (!isValidPhone(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedCustomer = widget.customer.copyWith(
                          customerName: customerName.trim(),
                          email: email.trim(),
                          phoneNumber: phoneNumber.trim(),
                        );
                        Navigator.pop(context, updatedCustomer);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}