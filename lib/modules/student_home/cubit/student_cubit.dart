import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/department.dart';
import '../../../models/faculty.dart';
import '../../../models/teacher.dart';
import 'student_states.dart';

class StudentCubit extends Cubit<StudentStates> {
  StudentCubit() : super(StudentHomeInitialState());

  static StudentCubit getInstance(BuildContext context) =>
      BlocProvider.of(context);

  Stream<QuerySnapshot> loadUsers() {
    return FirebaseFirestore.instance.collection("Users").snapshots();
  }

  List<Teacher> getTeachersByDepartment({
    required String faculty,
    required String dept,
    required List<QueryDocumentSnapshot> userCollectionSnapshot,
  }) {
    List<Teacher> teachersList = [];
    List<Map<String, dynamic>?>? docs = userCollectionSnapshot.map((e) {
      return e.data() as Map<String, dynamic>?;
    }).toList();
    for (var doc in docs) {
      String dep = doc!['department'];
      String fac = doc['faculty'];
      if (dep.toLowerCase().contains(dept.toLowerCase()) &&
          fac.toLowerCase().contains(faculty.toLowerCase())) {
        teachersList.add(Teacher.fromJSON(doc));
      }
    }
    return teachersList;
  }

  late List<Department> engineeringDepartments = [
    Department(
      arName: "قسم هندسة الحاسوب",
      enName: "Computer Engineering",
      isActive: true,
    ),
    Department(
      arName: "قسم الهندسة الكهربائية",
      enName: "Electrical Engineering",
      isActive: true,
    ),
    Department(
      enName: "Chemical Engineering",
      arName: "قسم الهندسة الكيميائية",
    ),
    Department(
      arName: "قسم هندسة الميكاترونكس",
      enName: "Mechatronics Engineering",
    ),
    Department(
      arName: "قسم الهندسة المدنية",
      enName: "Civil Engineering",
    ),
    Department(
      arName: "قسم هندسة الميكانيك",
      enName: "Mechanical Engineering",
    ),
    Department(
      arName: "قسم الهندسة المعمارية",
      enName: "Architecture Engineering",
    ),
    Department(
      arName: "قسم الهندسة الصناعية",
      enName: "Industrial Engineering",
    ),
  ];

// late List<Department> scienceDepartments = [
//   Department(
//     name: "Mathematics",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Physics",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Chemistry",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Biological Sciences",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Geology",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Clinical Sciences",
//     teachers: computerEngineeringTeachers,
//   ),
// ];
// late List<Department> agriculturalDepartments = [
//   Department(
//     name: "Horticulture and Crop Science",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Land Water and Environment",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Nutrition and Food Technology",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Animal Production",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Agricultural Economics and Agribusiness",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Plant Protection",
//     teachers: computerEngineeringTeachers,
//   ),
// ];
// late List<Department> itDepartments = [
//   Department(
//     name: "Computer Science",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Computer Information Systems",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Information Technology",
//     teachers: computerEngineeringTeachers,
//   ),
// ];
// late List<Department> medicineDepartments = [
//   Department(
//     name: "Anatomy and Histology",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Physiology and Biochemistry",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Pathology and Microbiology and Forensic Medicine",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Pharmacology",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Family and Community Medicine",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Internal Medicine",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "General Surgery",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Special Surgery",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Anesthesia and Intensive Care",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Pediatrics",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Obstetrics and Gynecology",
//     teachers: computerEngineeringTeachers,
//   ),
//   Department(
//     name: "Radiology",
//     teachers: computerEngineeringTeachers,
//   ),
// ];

  late List<Faculty> faculties = [
    Faculty(
      // name: "School of Engineering",
      arName: "كلية الهندسة",
      enName: "School of Engineering",
      image: "assets/images/faculties/Eng2.jpg",
      departments: engineeringDepartments,
      isActive: true,
    ),
    Faculty(
      // name: "School of Science",
      arName: "كلية العلوم",
      enName: "School of Science",
      image: "assets/images/faculties/science.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      // name: "King Abdullah II School of Information Technology",
      arName: "كلية الملك عبدالله الثاني لتكنولوجيا المعلومات",
      enName: "King Abdullah II School of Information Technology",
      image: "assets/images/faculties/it.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      // name: "School of Agriculture",
      arName: "كلية الزراعة",
      enName: "School of Agriculture",
      image: "assets/images/faculties/Agriculture.jpeg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الطب",
      enName: "School of Medicine",
      image: "assets/images/faculties/medicine.png",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية التمريض",
      enName: "School of Nursing",
      image: "assets/images/faculties/nursing.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الصيدلة",
      enName: "School of Pharmacy",
      image: "assets/images/faculties/pharmacy.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية طب الأسنان",
      enName: "School of Dentistry",
      image: "assets/images/faculties/dentistry.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية علوم التأهيل",
      enName: "School of Rehabilitation Sciences",
      image: "assets/images/faculties/Rehabilitation.jfif",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الآداب",
      enName: "School of Literature",
      image: "assets/images/faculties/litereture.jfif",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الأعمال",
      enName: "School of Business",
      image: "assets/images/faculties/business.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الحقوق",
      enName: "School of Law",
      image: "assets/images/faculties/law.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الشريعة",
      enName: "School of Shari'a",
      image: "assets/images/faculties/shari'a.bmp",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية العلوم التربوية",
      enName: "School of Educational Sciences",
      image: "assets/images/faculties/educational.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الرياضة",
      enName: "School of Sport Science",
      image: "assets/images/faculties/sports.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الفنون والتصميم",
      enName: "School of Arts and Design",
      image: "assets/images/faculties/arts.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الأمير الحسين بن عبدالله الثاني للدراسات الدولية",
      enName:
          "Prince Al Hussein Bin Abdullah II School of International Studies",
      image: "assets/images/faculties/international.jfif",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية اللغات الأجنبية",
      enName: "School of Foreign Languages",
      image: "assets/images/faculties/languages.jfif",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الآثار والسياحة",
      enName: "School of Archaeology and Tourism",
      image: "assets/images/faculties/tourism.jpg",
      departments: engineeringDepartments,
    ),
    Faculty(
      arName: "كلية الدراسات العليا",
      enName: "School of Graduate Studies",
      image: "assets/images/faculties/graduate.jfif",
      departments: engineeringDepartments,
    ),
  ];
}
