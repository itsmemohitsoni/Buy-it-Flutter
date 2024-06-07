class Item {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  Item(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl});

  factory Item.listFromJsonMap(Map<String, dynamic> json) {
    return Item(
        id: json['id'],
        name: json['name'],
        description: json['desc'],
        price: json['price'],
        imageUrl: json['image']);
  }
}
