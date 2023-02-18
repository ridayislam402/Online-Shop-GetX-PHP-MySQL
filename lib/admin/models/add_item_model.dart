class AddItemModel
{
  int? item_id;
  String? name;
  String? rating;
  String? tags;
  String? price;
  String? sizes;
  String? colors;
  String? description;
  String? image;


  AddItemModel(
      {this.item_id,
      this.name,
      this.rating,
      this.tags,
      this.price,
      this.sizes,
      this.colors,
      this.description,
      this.image});

  Map<String, dynamic> toJson(String imageSelectedBase64)=>
      {
        "item_id": item_id.toString(),
        "name": name,
        "rating": rating,
        "tags": tags,
        "price": price,
        "sizes": sizes,
        "colors": colors,
        "description": description,
        "image": image,
        "imageFile": imageSelectedBase64,
      };
}