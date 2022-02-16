import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/screens/roles/provider/role_provider.dart';

import '../../../constants.dart';
import '../models/user_role_model.dart';

class RoleFields extends StatefulWidget {
  final UserRoleModel? model;
  const RoleFields({Key? key, this.model}) : super(key: key);
  @override
  _RoleFieldsState createState() => _RoleFieldsState();
}

class _RoleFieldsState extends State<RoleFields> {
  final roleText = TextEditingController();
  RoleProviderNew? per;



  @override
  void initState() {
    if(widget.model!=null){
      roleText.text=widget.model!.roleName;
    }
    super.initState();


    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {


      Provider.of<RoleProviderNew>(context, listen: false).getPages();


    });
  }

  @override
  void dispose() {

    roleText.dispose();
    // Provider.of<RoleProviderNew>(listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GestureDetector(s
          //     onTap: () {
          //       Navigator.pushNamed(context, roleList);
          //     },
          //     child: columTextFileds(context)),
          // const CurrentUser(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Focus(
              onFocusChange: (f) {

              },
              child: Consumer<RoleProviderNew>(
                builder: (context,snap,child){
                  return TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter value for role";
                      }
                      return null;
                    },
                    onChanged: (val){
                      snap.updateCurrentRoleText(val);
                    },
                    onSaved: (value) {},

                    controller: roleText,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: const TextStyle(
                          color: whiteColor,
                          fontSize: 13,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        hintText: 'Role',
                        hintStyle: const TextStyle(color: textColor),
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red.shade500, width: 1)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade500, width: 1)),
                        disabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30)),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30))),

                  );
                },

              ),
            ),
          ),
          spacer(10),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              "Add Permissions",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          Consumer<RoleProviderNew>(builder: (context, snapshot, child) {
            return snapshot.loadingFOr?const Center(child: CircularProgressIndicator(),):
                 ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.pageList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return UserRolePermissions(
                          permission: snapshot.pagePermissions[index]);
                    });
          })
        ],
      ),
    );
  }
}

Widget columTextFileds(BuildContext context, TextEditingController edit) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        controller: edit,
        decoration: const InputDecoration(
            labelText: rolename,
            enabled: false,
            fillColor: Colors.white70,
            filled: true,
            labelStyle: TextStyle(color: whiteColor),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: rolename,
            hintStyle: TextStyle(color: textColor),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: whiteColor,
              width: 1,
            ))),
      ));
}

class UserRolePermissions extends StatelessWidget {
  final RolePermission permission;
  const UserRolePermissions({Key? key, required this.permission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleProviderNew>(

      builder: (context, snapshot,child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: black90,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Icon(Icons.phone_android_outlined),
                      Text(
                       permission.pageName.pageName,
                        style: const TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      spacer(10),
                    ],
                  ),
                ),
                spacer(10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: lightBlack,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "View",
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: permission.read,
                                    onChanged: (value) {
                                      permission.read=value;
                                      snapshot.addPermissionList(permission);
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: lightBlack,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create",
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: permission.create,
                                    onChanged: (value) {
                                      permission.create=value;
                                      snapshot.addPermissionList(permission);
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: lightBlack,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: permission.update,
                                    onChanged: (value) {
                                      permission.update=value;
                                      snapshot.addPermissionList(permission);
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: lightBlack,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: permission.delete,
                                    onChanged: (value) {
                                      permission.delete=value;
                                      snapshot.addPermissionList(permission);
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
