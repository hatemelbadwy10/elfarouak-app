import 'package:flutter/material.dart';

class AddWidget extends StatelessWidget {
  const AddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add), // أيقونة الزائد
      onPressed: () {
        showMenu(
          context: context,
          items: [
            const PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(Icons.person_add,
                  color: Colors.black,
                  ), // أيقونة "إضافة مستخدم"
                  SizedBox(width: 10),
                  Text("إضافة مستخدم"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.transfer_within_a_station,
                  color: Colors.black,
                  ),
                  // أيقونة "إضافة تحويل"
                  SizedBox(width: 10),
                  Text("إضافة تحويل"),
                ],
              ),
            ),
          ],
          elevation: 8.0,
          position: const RelativeRect.fromLTRB(
            0.0, // المسافة من اليسار
            80.0, // المسافة من الأعلى
            100.0, // المسافة من اليمين
            0.0, // المسافة من الأسفل
          ), // تأثير الظل للقائمة
        ).then((value) {
          if (value == 1) {
            // عملية "إضافة مستخدم"
          } else if (value == 2) {
            // عملية "إضافة تحويل"
          }
        });
      },
    );
  }
}
