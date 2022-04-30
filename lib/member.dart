
class Member {
  String? name;
  int? id;

  Member({
    this.name,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}