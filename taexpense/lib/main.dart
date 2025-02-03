import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Home());
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainApp()
    );
  }
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TA Expense'),
          backgroundColor: Colors.blue,
        ), 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello World!'),
              const AddTransaction(),
              const Text('Another Text Widget'),
              ElevatedButton(
  child: const Text('Add transaction'),
  onPressed: () { 
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondRoute()),
    );
  },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  _AddTransactionState createState() => _AddTransactionState();  
  }
class _AddTransactionState extends State<AddTransaction> {
  String _displayText = 'This is a stateful widget!';

  void _updateText() {
    setState(() {
      _displayText = 'The text has been updated!';
    });
  }
   @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_displayText),
        ElevatedButton(
          onPressed: _updateText,
          child: const Text('Update Text'),
        ),
      ],
    );
  }
}
class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final _formKey = GlobalKey<FormState>();
// Text editing controllers
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController finalTextController = TextEditingController();

  // Drop-down values
  Map<String, String>? dropdownValue0;
  String? dropdownValue1;
  String? dropdownValue2;
  String? dropdownValue3;

    // Currency data
  final List<Map<String, String>> _currencies = [
    {'flag': '🇺🇸', 'code': 'USD'},
    {'flag': '🇪🇺', 'code': 'EUR'}, 
    {'flag': '🇻🇳', 'code': 'VND'},
    {'flag': '🇸🇬', 'code': 'SGD'},
    {'flag': '🇬🇧', 'code': 'GBP'},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitForm() async {
                          final url = Uri.parse('https://yourapiendpoint.com/submit');
                          final response = await http.post(
                            url,
                            headers: {'Content-Type': 'application/json'},
                            body: json.encode({
                              'content': textController1.text,
                              'currency': dropdownValue0!['code'],
                              'amount': textController2.text,
                              'type': dropdownValue1,
                              'date': dateController.text,
                              'category': dropdownValue2,
                              'tags': dropdownValue3,
                              'notes': finalTextController.text,
                            }),
                          );

                          if (response.statusCode == 200) {
                            // Handle successful submission
                            print('Form submitted successfully');
                          } else {
                            // Handle error
                            print('Failed to submit form');
                          }
                        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: textController1,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  // Currency Dropdown
                  Expanded(
                    flex: 1, // Adjusts the width ratio for dropdown
                    child: DropdownButtonFormField<Map<String, String>>(
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                      items: _currencies
                          .map((currency) => DropdownMenuItem(
                                value: currency,
                                child: Row(
                                  children: [
                                    Text(currency['flag']!),
                                    SizedBox(width: 8),
                                    Text(currency['code']!),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        dropdownValue0 = value;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a currency' : null,
                      selectedItemBuilder: (context) => _currencies
                          .map((currency) => Row(
                                children: [
                                  Text(currency['flag']!),
                                  SizedBox(width: 8),
                                  Text(currency['code']!),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(width: 10), // Margin between dropdown and text field
                  // Amount Text Field
                  Expanded(
                    flex: 3, // Adjusts the width ratio for text field
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final n = num.tryParse(value);
                        if (n == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: ['income', 'expense']
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue1 = value; // Update dropdownValue1 when a new value is selected
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select the transaction type' : null,
                    ),
                    SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),

              ),
              SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Food & Drinks', '2', '3']
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                            dropdownValue2 = value; // Update dropdownValue1 when a new value is selected
                          });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                    
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tags',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Personal', '5', '6']
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue3 = value; // Update dropdownValue1 when a new value is selected
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a tag' : null,
                    ),
                    SizedBox(height: 10),
              TextFormField(
                controller: finalTextController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                    },
                    style: ButtonStyle(
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: const Color.fromRGBO(255, 203, 54, 244))
    )
  )
),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission here
                        

                        

                        _submitForm();
                        print('Form submitted');
                      }
                    },
                    style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 203, 54, 244)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: const Color.fromARGB(255, 203, 54, 244))
          )
        )
      ),
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



