import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class UserTabMenu {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  UserTabMenu({required this.icon, required this.title, this.onTap});
}

final List<UserTabMenu> menus = [
  UserTabMenu(icon: HugeIcons.strokeRoundedEditUser02, title: 'Edit Profile'),
  UserTabMenu(icon: HugeIcons.strokeRoundedInformationSquare, title: 'About'),
  UserTabMenu(icon: HugeIcons.strokeRoundedHelpSquare, title: 'Faqs'),
  UserTabMenu(icon: HugeIcons.strokeRoundedComment01, title: 'Send Feedback'),
  UserTabMenu(icon: HugeIcons.strokeRoundedSquareLock02, title: 'Change Password'),
  UserTabMenu(icon: HugeIcons.strokeRoundedLogoutSquare01, title: 'Logout'),
];

class MenuTile extends StatelessWidget {
  final UserTabMenu menu;
  final bool showDivider;
  final VoidCallback? onTap;

  const MenuTile({Key? key, required this.menu, this.showDivider = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          leading: Icon(menu.icon, size: 24),
          title: Text(
            menu.title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF353232)),
          ),
          onTap: onTap ?? menu.onTap,
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 63.0),
            child: const Align(
              alignment: Alignment.centerRight,
              child: Divider(
                color: Color(0xFFF7F7F9),
                height: 1,
                thickness: 2,
              ),
            ),
          ),
      ],
    );
  }
}