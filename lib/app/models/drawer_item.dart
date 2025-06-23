import 'package:flutter/material.dart';

class DrawerItems{
  /*static final home = DrawerItem(id: 1, title: 'Home', icon: Icons.home);
  static final aboutUs = DrawerItem(id: 2, title: 'About Us', icon: Icons.info);
  static final myOrders = DrawerItem(id: 3, title: 'My Orders', icon: Icons.shopping_cart);
  static final login = DrawerItem(id: 4, title: 'Sign In', icon: Icons.login);
  static final logout = DrawerItem(id: 5, title: 'Logout', icon: Icons.logout);
  static final privacyPolicy = DrawerItem(id: 6, title: 'Privacy Policy', icon: Icons.settings);
  static final termsCondition = DrawerItem(id: 7, title: 'Terms & Conditions', icon: Icons.notifications);
  static final customerSupport = DrawerItem(id: 8, title: 'Customer Support', icon: Icons.feedback_outlined);
  static final deActivateAccount = DrawerItem(id: 10, title: 'Deactivate Account', icon: Icons.cancel);*/
}
class DrawerItem{
  int id;
  String title;
  IconData icon;
  bool isSelected;

  DrawerItem({required this.id, required this.title, required this.icon, required this.isSelected});
}
