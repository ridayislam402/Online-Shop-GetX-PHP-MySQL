
class UserModel{
  int id;
  String name;
  String email;
  String password;

  UserModel(
      this.id,
      this.name,
      this.email,
      this.password
      );
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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