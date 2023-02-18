
class AdminModel{
  int id;
  String name;
  String email;
  String password;

  AdminModel(
      this.id,
      this.name,
      this.email,
      this.password
      );
  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
      int.parse(json["id"]),
      json["name"],
      json["email"],
      json["password"]
  );
  Map<String, dynamic> toMap()=>{
    'id' : id.toString(),
    'name' : name,
    'email' : email,
    'password' : password
  };

}