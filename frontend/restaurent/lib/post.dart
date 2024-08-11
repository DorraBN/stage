import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(Posts());
}

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Image App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostImagePage(),
    );
  }
}

class PostImagePage extends StatefulWidget {
  @override
  _PostImagePageState createState() => _PostImagePageState();
}

class _PostImagePageState extends State<PostImagePage> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();

  List<dynamic> posts = [];

  Future<void> fetchPosts() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/postss'); // Remplacez par votre URL d'API

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch posts')),
      );
    }
  }

  Future<void> createPost(String body, String imageUrl) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/posts'); // Remplacez par votre URL d'API

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': body,
        'user_id': 1, // Utilisateur fixe pour cet exemple
        'image': imageUrl, // Envoyer l'URL de l'image
      }),
    );

    if (response.statusCode == 201) {
      fetchPosts(); // Rafraîchir la liste des posts après en avoir créé un
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Récupérer les posts au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create and View Posts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(labelText: 'Body'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createPost(_bodyController.text, _imageUrlController.text);
                      }
                    },
                    child: Text('Create Post'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.network(
                        post['image'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(post['body']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
