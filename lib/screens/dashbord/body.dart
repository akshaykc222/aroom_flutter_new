import 'package:flutter/material.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/screens/dashbord/componets/menus.dart';
import 'package:seed_sales/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  final key1 = UniqueKey();
  final key2 = UniqueKey();

  Future<Map<String, dynamic>> getLogindetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print("email ${_pref.getString("email")}");
    Map<String, dynamic> d = {
      "email": _pref.getString("email"),
      "business": _pref.getString("select_bus_detail")
    };
    return d;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar('Aroom', [], context),
      body: Stack(children: [
        Column(
          children: const [AdminMenu()],
        ),
      ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blackColor,
      //   onPressed: () {
      //     _onTap();
      //   },
      //   child: Center(
      //       child: AnimatedIcon(
      //           icon: AnimatedIcons.menu_close, progress: _myAnimation!)),
      // ),
    );
  }
}
