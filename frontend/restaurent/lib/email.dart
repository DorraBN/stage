import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact Form'),
        ),
        body: ContactForm(),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _subject = '';
  String _message = '';
  bool _isLoading = false; // Variable to control the loading state

  Future<void> _sendEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/send-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email,
          'subject': _subject,
          'message': _message,
        }),
      );

      setState(() {
        _isLoading = false; // Hide loading spinner
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email envoyé avec succès !')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'envoi de l\'email')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add scrolling capability
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
        children: <Widget>[
          // Additional content
          Image.asset('assets/contact_image.png'), // Add an image (make sure you have the image in your assets)
          SizedBox(height: 10),
          Text(
            'Nous serions ravis d\'avoir de vos nouvelles ! Remplissez le formulaire ci-dessous pour nous envoyer un message.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Divider(), // Divider to separate sections
          SizedBox(height: 20),
          // Form content
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Votre email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Sujet'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un sujet';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _subject = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Message'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un message';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _message = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator()) // Show loading spinner
                    : ElevatedButton(
                        onPressed: _sendEmail,
                        child: Text('Envoyer'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
