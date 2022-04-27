/// Database에서 사용할 구조

class Menu {
  String? title;    // 메뉴명
  int? active;      // 활성화 여부
  int? id;

  Menu({
    this.title,
    this.active,
    this.id,
  });

  /// flutter의 sqflite 패키지는 데이터를 map 형태로 다룬다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'active': active,
    };
  }
}