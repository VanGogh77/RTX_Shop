
class Product {
  late final int id;
  late final String name;
  late final double price;
  late final String image;
  late final String description;
  late final String category;
  late int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.quantity,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    price = json['price'] as double;
    image = json['image'] as String;
    description = json['description'] as String;
    category = json['category'] as String;
    quantity = json['quantity'] as int;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'image': image,
    'description': description,
    'category': category,
    'quantity': quantity,
  };
}
