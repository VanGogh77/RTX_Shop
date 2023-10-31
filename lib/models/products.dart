class ProductModel{
  int? id;
  String? name;
  String? category;
  String? image;
  String? description;
  double? price;
  int? quantity;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.image,
    this.description,
    this.price,
    this.quantity
  });

  ProductModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
  }

}