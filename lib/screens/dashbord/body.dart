import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/bussiness/models/bussinessmode.dart';
import 'package:seed_sales/screens/dashbord/componets/menus.dart';

import 'package:seed_sales/screens/settings/body.dart';
import 'package:seed_sales/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';



class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  final key1 = UniqueKey();
  final key2 = UniqueKey();

  Future<Map<String,dynamic>> getLogindetails() async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    print("email ${_pref.getString("email")}");
    Map<String,dynamic> d={
      "email":_pref.getString("email"),
      "business":_pref.getString("select_bus_detail")
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
      appBar: PreferredSize(
        preferredSize: Size(SizeConfig.screenWidth!, 100),
        child: Container(
          height: 80,
          color: blackColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:  [
             InkWell(
               onTap: (){

               },
               child: Padding(
                  padding: const EdgeInsets.only(left: 25,bottom: 15),
                  child: Text(appName,style: TextStyle(color: textColor,fontSize: SizeConfig.blockSizeHorizontal!*6,fontWeight: FontWeight.bold),),
                ),
             ),

              FutureBuilder(
                future: getLogindetails(),
                builder: (context,snap) {
                  if( snap.hasData){

                    final d=snap.data as Map<String,dynamic>;

                    BusinessModel? m=d['business']==null?null:BusinessModel.fromJson(jsonDecode(d['business']));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width:80,
                              child: Text(d['email'],style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.fade,maxLines: 2,),),
                          const SizedBox(width: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:m==null|| m.image==null||m.image==""?SvgPicture.asset('assets/icons/user.svg',height: 40.0,
                              width: 40.0,color: Colors.white,): Image.network(
                              m.image!,
                              height: 40.0,
                              width: 40.0,
                            ),
                          )
                        ],
                      ),
                    );
                  }else{
                    return const CircularProgressIndicator();
                  }
                }
              )

            ],
          ),
        ),
      ),
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
      bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          color: black90,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[




                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: whiteColor,
                      ),
                      onPressed: () {

                      }),
                ),
                const SizedBox(width: 40), // The dummy child
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>const Settings()));
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
