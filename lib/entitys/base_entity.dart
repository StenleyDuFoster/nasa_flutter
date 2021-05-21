 abstract class BaseEntity { 
  String? error;

  BaseEntity({
    this.error,
  }) : super();

  fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}