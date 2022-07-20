class Item {
  final int id;
  final String name;
  final String? type;
  final String description;
  final int price;
  final String imagePath;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      json['name'],
      json['type'],
      json['description'],
      json['price'],
      json['image_path'],
    );
  }

  Item(
    this.id,
    this.name,
    this.type,
    this.description,
    this.price,
    this.imagePath,
  );
}
