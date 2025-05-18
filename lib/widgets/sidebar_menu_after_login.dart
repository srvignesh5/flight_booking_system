import 'package:flutter/material.dart';
import 'app_styles.dart';

class SideBarMenuAfterLogin extends StatelessWidget {
  final Function(String) onMenuItemSelected;

  const SideBarMenuAfterLogin({Key? key, required this.onMenuItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: AppColors.appGradient,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: AppTextStyles.menuHeader,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => onMenuItemSelected("Profile"),
          ),
          ListTile(
            leading: const Icon(Icons.flight_takeoff),
            title: const Text('Add Flight'),
            onTap: () => onMenuItemSelected("AddFlight"),
          ),
          ListTile(
            leading: const Icon(Icons.flight),
            title: const Text('Flights'),
            onTap: () => onMenuItemSelected("Flights"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => onMenuItemSelected("Logout"),
          ),
        ],
      ),
    );
  }
}



