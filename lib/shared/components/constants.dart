bool? isOnBoardingDone;
String? uId;
final List<Map<String, String>> boardingData = [
  {
    'arabicTitle': 'اوجد مكتب مدرسك',
    'englishTitle': 'Get to your Instructor\'s office',
    'image': 'assets/images/studentsAndDocs.jpg',
    'arabicBody':
        'يمكنك معرفة الوقت المناسب للذهاب إلى مكتب مدرسك لمقابلته وطرح أسئلتك عليه.',
    'englishBody':
        'You can know the right time to go to your instructor\'s office in JU to meet him and ask him your questions.',
  },
  {
    'arabicTitle': '!الوقت المثالي',
    'englishTitle': 'The perfect Time!',
    'image': 'assets/images/doc1.jpg',
    'arabicBody':
        'سيتم إخطارك على الفور عندما يكون المدرس الذي تريد مقابلته متاحًا في مكتبه.',
    'englishBody':
        'You will get notified immediately when the instructor you want to meet is available in his office.',
  },
  {
    'arabicTitle': 'متوفرة في كلية الهندسة',
    'englishTitle': 'Available at faculty of Engineering',
    'image': 'assets/images/faculties/EngLogo.png',
    'arabicBody':
        'هذه الخدمة متوفرة الآن في جميع أقسام كلية الهندسة في الجامعة الأردنية.',
    'englishBody':
        'This service is now available in all departments of the Faculty of Engineering at the University of Jordan.',
  },
];

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  // ignore: avoid_print
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
