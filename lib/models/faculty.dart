import 'department.dart';

class Faculty {
  String arName;
  String enName;
  String image;
  bool isActive;

  List<Department> departments;

  Faculty({
    required this.arName,
    required this.enName,
    required this.image,
    required this.departments,
    this.isActive = false,
  });
}
