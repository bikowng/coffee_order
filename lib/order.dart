
class Order {
  String? memberName;
  String? menuName;

  Order({
    this.memberName,
    this.menuName,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'menuName': menuName,
    };
  }
}