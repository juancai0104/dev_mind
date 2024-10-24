class Progress {
  final int userId;
  final int moduleId;
  final double progressPercentage;

  Progress({
    required this.userId,
    required this.moduleId,
    required this.progressPercentage,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'],
      moduleId: json['moduleId'],
      progressPercentage: json['progressPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'moduleId': moduleId,
      'progressPercentage': progressPercentage
    };
  }
}