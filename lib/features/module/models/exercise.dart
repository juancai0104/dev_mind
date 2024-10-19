class Exercise {
  final int id;
  final int moduleId;
  final int difficultyId;
  final String description;
  final bool requiresInput;
  final String codeType;
  final String? functionName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise({
    required this.id,
    required this.moduleId,
    required this.difficultyId,
    required this.description,
    required this.requiresInput,
    required this.codeType,
    this.functionName,
    required this.createdAt,
    required this.updatedAt
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      moduleId: json['moduleId'],
      difficultyId: json['difficultyId'],
      description: json['description'],
      requiresInput: json['requiresInput'],
      codeType: json['codeType'],
      functionName: json['functionName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'])
    );
  }
}
