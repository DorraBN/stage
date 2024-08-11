import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  XFile? _pickedFile;
  String? _imageDataUrl;
  final picker = ImagePicker();
  late Future<List<dynamic>> _images;

  @override
  void initState() {
    super.initState();
    _images = _fetchImages();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        _pickedFile = pickedFile;
        _imageDataUrl = base64Image;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_addFormKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/imageadd'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': _titleController.text,
            'image': _imageDataUrl,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image added successfully')),
          );
          setState(() {
            _images = _fetchImages();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add image: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add image: $e')),
        );
      }
    }
  }

 Future<List<dynamic>> _fetchImages() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/images'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    // Vérifier si jsonData est null ou si la liste est vide
    if (jsonData == null) {
      return []; // Retourner une liste vide si jsonData est null
    }

    if (jsonData is Map<String, dynamic>) {
      return jsonData['data'] as List<dynamic>? ?? [];
    }

    if (jsonData is List<dynamic>) {
      return jsonData;
    }

    throw Exception('Unexpected JSON format');
  } else {
    throw Exception('Failed to load images');
  }
}

  Widget _buildImageList(List<dynamic> images) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        final title = image['title'] ?? 'No Title';
        final imageUrl = 'http://127.0.0.1:8000' + image['url'];

        return ListTile(
          title: Text(title),
          leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildImage() {
    return _pickedFile != null
        ? Image.memory(
            base64Decode(_imageDataUrl!),
            width: 100,
            height: 100,
          )
        : Text('No image selected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Image Title'),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: getImage,
                          child: _buildImage(),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _uploadImage,
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FutureBuilder<List<dynamic>>(
                  future: _images,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load images: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No images found'));
                    } else {
                      return _buildImageList(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
