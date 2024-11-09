class Progress {
  final int userId;
  final int moduleId;
  final double progressPercentage;

  Progress({required this.userId, required this.moduleId, required this.progressPercentage});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'] as int,
      moduleId: json['moduleId'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'moduleId': moduleId,
    'progressPercentage': progressPercentage,
  };
}
