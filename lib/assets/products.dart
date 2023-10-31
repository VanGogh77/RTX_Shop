
/// Testing


class Note {
  late int id;
  late String name;
  late String category;
  late String image;
  late String description;
  late double price;
  late int quantity;

  Note(
    this.id,
    this.name,
    this.category,
    this.image,
    this.description,
    this.price,
    this.quantity,
  );

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
  }
}