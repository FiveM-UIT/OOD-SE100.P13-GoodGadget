import 'package:flutter/material.dart';
import 'package:gizmoglobe_client/objects/customer.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String customerName;
  late String email;
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    customerName = widget.customer.customerName;
    email = widget.customer.email;
    phoneNumber = widget.customer.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: customerName,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => customerName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => phoneNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update customer details
                    final updatedCustomer = widget.customer.copyWith(
                      customerName: customerName,
                      email: email,
                      phoneNumber: phoneNumber,
                    );
                    Navigator.pop(context, updatedCustomer);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}