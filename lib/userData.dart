class UserData {
  final String? name;
  final String? nickname;
  final String? email;
  final DateTime? birthdate;
  final DateTime? weddingAnniversary;
  final List<Anniversary>? anniversaries;
  final String? imagePath;

  UserData({
    this.name,
    this.nickname,
    this.email,
    this.birthdate,
    this.weddingAnniversary,
    this.anniversaries,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    // ここにマッピングコードを実装する
    return {
      'name': name,
      'nickname': nickname,
      'email': email,
      'birthdate': birthdate?.toIso8601String(),
      'weddingAnniversary': weddingAnniversary?.toIso8601String(),
      'anniversaries': anniversaries?.map((e) => e.toMap())?.toList(),
      'imagePath': imagePath,
    };
  }
}

class Anniversary {
  final String? description;
  final DateTime? date;

  Anniversary({this.description, this.date});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'date': date?.toIso8601String(),
    };
  }
}
