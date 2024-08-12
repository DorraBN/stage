class Product {
  final String image;
  final String title;
  final int id;

  Product({
    required this.id,
    required this.image,
    required this.title,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Fournir une valeur par défaut si 'id' est null
      title: json['name'] ?? 'Unknown', // Fournir une valeur par défaut si 'title' est null
      image: json['image'] ?? '', // Fournir une valeur par défaut si 'image' est null
    );
  }
}
