class Product {
  final String image;
  final String title;
  final int id;
  final double price;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Fournir une valeur par défaut si 'id' est null
      title: json['name'] ?? 'Unknown', // Fournir une valeur par défaut si 'title' est null
      image: json['image'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      // Convertir correctement le prix en double
    );
  }
}
