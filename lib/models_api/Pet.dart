class Pet {
  int id;
  String name;
  int age;
  String desc;
  String image;
  int typeId;
  int statusId;

  Pet(
    {
      this.id,
      this.name,
      this.age,
      this.desc,
      this.image,
      this.typeId,
      this.statusId
    }
  );

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      desc: json['desc'],
      image: json['image'] ?? 'assets/image.png',
      typeId: json['type_id'],
      statusId: json['status_id'],
    );
  }

  Map toMap(){
    var map = Map<String, dynamic>();

    map['name'] = name;
    map['desc'] = desc;
    map['age'] = age.toString();
    map['image'] = image;
    map['typeId'] = typeId.toString();
    map['statusId'] = statusId.toString();

    return map;
  }
}