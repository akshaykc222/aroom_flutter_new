import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seed_sales/componets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key}) : super(key: key);

  @override
  _AdminMenuState createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  List<Widget> itemList = [];

  @override
  void initState() {
    itemList = [
      // MenuCard(icon: Icons.business_center_outlined, title: "Business", function: (){
      //
      //   Navigator.pushNamed(context, business);
      // }),
      // MenuCard(icon: Icons.vpn_key_outlined, title: "Roles", function: (){
      //   Navigator.pushNamed(context, roleList);
      // }),
      MenuCard(
          icon: Icons.work_outline,
          title: "Designations",
          function: () {
            Navigator.pushNamed(context, designation);
          }),
      MenuCard(
          icon: Icons.person_outline,
          title: "Staffs",
          function: () {
            Navigator.pushNamed(context, userCreation);
          }),
      // MenuCard(icon: Icons.monetization_on_outlined, title: "Tax", function: (){
      //   Navigator.pushNamed(context, taxNav);
      // }),
      MenuCard(
          icon: Icons.category,
          title: "Categories",
          function: () {
            Navigator.pushNamed(context, category);
          }),
      MenuCard(
          icon: Icons.category,
          title: "Projects",
          function: () {
            Navigator.pushNamed(context, products);
          }),
      MenuCard(
          icon: Icons.category,
          title: "Income",
          function: () {
            Navigator.pushNamed(context, incomeNav);
          }),
      MenuCard(
          icon: Icons.money_off,
          title: "Expenses",
          function: () {
            Navigator.pushNamed(context, expenseNav);
          }),
      MenuCard(
          icon: Icons.people_alt_outlined,
          title: "Clients",
          function: () {
            Navigator.pushNamed(context, customers);
          }),
      MenuCard(
          icon: Icons.chat_bubble_outline,
          title: "Enquiry",
          function: () {
            Navigator.pushNamed(context, enquiry);
          }),
      MenuCard(
          icon: Icons.logout,
          title: "Logout",
          function: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.clear();
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          }),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                    MediaQuery.of(context).size.width * 0.4 / 100),
            itemCount: itemList.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return itemList[index];
            }),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function function;
  const MenuCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => function(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
              spacer(8),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
