import 'package:flutter/material.dart';

class ProfileModel {
  ProfileModel(
      {@required this.name,
      @required this.title,
      @required this.photo,
      @required this.born,
      @required this.died,
      @required this.about,
      @required this.profileColor});

  final String name;
  final String title;
  final String photo;
  final String born;
  final String died;
  final String about;
  final Color profileColor;
}

final profileData = ProfileModel(
  name: 'Al-Khwarizmi',
  title: 'Mathematician and Astronomer',
  photo: 'user_empty.png',
  born: 'c. 780',
  died: 'c. 850',
  about:
      'Muhammad ibn Musa al-Khwarizmi was a Persian mathematician, astronomer, astrologer geographer and a scholar in the House of Wisdom in Baghdad. He was born in Persia of that time around 780. Al-Khwarizmi was one of the learned men who worked in the House of Wisdom.\n\nAl-Khwarizmi developed the concept of the algorithm in mathematics (which is a reason for his being called the grandfather of computer science by some people).\n\nAl-Khwarizmi’s algebra is regarded as the foundation and cornerstone of the sciences. To al-Khwarizmi we owe the world “algebra,” from the title of his greatest mathematical work, Hisab al-Jabr wa-al-Muqabala. The book, which was twice translated into Latin, by both Gerard of Cremona and Robert of Chester in the 12th century, works out several hundred simple quadratic equations by analysis as well as by geometrical example. It also has substantial sections on methods of dividing up inheritances and surveying plots of land. It is largely concerned with methods for solving practical computational problems rather than algebra as the term is now understood.',
  profileColor: Color(0xFF1f6fff),
);
