import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _responseText = '';
  double wallet = 0;
  bool _isLoading = false;

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
    });
    final String phoneNumber = _phoneNumberController.text;
    final String amount = _amountController.text;

    final Uri url = Uri.parse('http://xxx.xxx.x.xx:3000/submit-data'); // your ip

    try {
      final response = await http.post(
        url,
        body: {
          'phone': phoneNumber,
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          wallet += double.tryParse(amount) ?? 0.0;
          _responseText = response.body;
        });
      } else {
        _isLoading = false;
        print('Error: ${response}');
        setState(() {
          _responseText = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      print(e);
      _isLoading = false;
      setState(() {
        _responseText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ebirr Mobile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Wallet: " + wallet.toString()),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendRequest,
              child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
            ),
            SizedBox(height: 16),
            Text(_responseText),
          ],
        ),
      ),
    );
  }
}
