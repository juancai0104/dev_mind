class Module {
  final int id;
  final int moduleId;
  final String description;

  Module({
    required this.id,
    required this.moduleId,
    required this.description,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      moduleId: json['moduleId'],
      description: json['description'],
    );
  }
}