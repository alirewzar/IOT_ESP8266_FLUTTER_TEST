import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ESP Controller', home: MessagePage());
  }
}

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _ipController = TextEditingController(
    text: '192.168.4.1',
  );
  TextEditingController _msgController = TextEditingController();
  TextEditingController _ssidController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _response = '';

  Future<void> sendMessage() async {
    final ip = _ipController.text;
    final msg = _msgController.text;

    final uri = Uri.parse('http://$ip/message?text=$msg');
    try {
      final res = await http.get(uri).timeout(Duration(seconds: 5));
      setState(() {
        _response = res.body;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> sendWiFiSettings() async {
    final ip = _ipController.text;
    final ssid = _ssidController.text;
    final pass = _passController.text;

    final uri = Uri.parse('http://$ip/setwifi?ssid=$ssid&pass=$pass');
    try {
      final res = await http.get(uri).timeout(Duration(seconds: 5));
      setState(() {
        _response = res.body;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ESP Communicator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: 'ESP IP (e.g., 192.168.4.1)',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _msgController,
                decoration: InputDecoration(labelText: 'Enter message to ESP'),
              ),
              ElevatedButton(
                onPressed: sendMessage,
                child: Text('Send Message'),
              ),
              Divider(),
              TextField(
                controller: _ssidController,
                decoration: InputDecoration(labelText: 'WiFi SSID'),
              ),
              TextField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'WiFi Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: sendWiFiSettings,
                child: Text('Set WiFi'),
              ),
              SizedBox(height: 20),
              Text('Response: $_response'),
            ],
          ),
        ),
      ),
    );
  }
}
