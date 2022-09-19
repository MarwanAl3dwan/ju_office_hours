// ignore_for_file: constant_identifier_names

class Teacher {
  String name;
  String id;
  bool isOnline;
  FacultyName faculty;
  Dept department;
  int time;
  String? image;

  Teacher({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.faculty,
    required this.department,
    required this.time,
    this.image,
  });

  factory Teacher.fromJSON(Map<String, dynamic> data) {
    return Teacher(
      id: data['id'],
      name: data['userName'],
      isOnline: data['isOnline'],
      faculty: facultyNameStringToEnum(data['faculty']),
      department: deptNameStringToEnum(data['faculty'], data['department']),
      time: data['time'],
      image: data['image'],
    );
  }
}

enum FacultyName {
  Engineering,
  Other,
}

enum Dept {
  Computer_Engineering,
  Chemical_Engineering,
  Electrical_Engineering,
  Mechanical_Engineering,
  Civil_Engineering,
  Industrial_Engineering,
  Architecture_Engineering,
  Mechatronics_Engineering,
  Other,
}

FacultyName facultyNameStringToEnum(String facultyName) {
  String faculty = facultyName.toLowerCase();
  if (faculty.contains("eng")) {
    return FacultyName.Engineering;
  } else {
    return FacultyName.Other;
  }
}

Dept deptNameStringToEnum(String facultyName, String deptName) {
  String faculty = facultyName.toLowerCase();
  String department = deptName.toLowerCase();

  if (faculty.contains('eng')) {
    if (department.contains("comp")) {
      return Dept.Computer_Engineering;
    } else if (department.contains("chemic")) {
      return Dept.Chemical_Engineering;
    } else if (department.contains("electric")) {
      return Dept.Electrical_Engineering;
    } else if (department.contains("mechanic")) {
      return Dept.Mechanical_Engineering;
    } else if (department.contains("civil")) {
      return Dept.Civil_Engineering;
    } else if (department.contains("indus")) {
      return Dept.Industrial_Engineering;
    } else if (department.contains("arch")) {
      return Dept.Architecture_Engineering;
    } else if (department.contains("mechatronic")) {
      return Dept.Mechatronics_Engineering;
    } else {
      return Dept.Other;
    }
  } else {
    return Dept.Other;
  }
}
