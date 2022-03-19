import 'dart:developer';


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';

import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/enquiry/body.dart';
import 'package:seed_sales/screens/enquiry/model/appointmentsmodel.dart';

import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';

import 'package:seed_sales/screens/services/componets/select_time_slot.dart';

import 'package:seed_sales/screens/user/provider/users_provider.dart';

import '../../../constants.dart';

class OrderProducts extends StatefulWidget {
  final EnquiryModel? model;
  const OrderProducts({Key? key,  this.model}) : super(key: key);

  @override
  _OrderProductsState createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {



  final type=TextEditingController();
  final source=TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? bookDate;
  TimeOfDay? bookTime;




  getDataForUpdate() async{

  // actual_fee.text=widget.model!.customerFee.toString();
    var p= Provider.of<CustomerProvider>(context,listen: false);
    var a= Provider.of<UserProviderNew>(context,listen: false);
    var pr= Provider.of<ProjectProvider>(context,listen: false);

    var psd= Provider.of<AppointmentProvider>(context,listen: false);


  }

  @override
  void initState() {
    if(widget.model!=null){
      log("selected status ${widget.model!.toJson()}");
      // name.text=widget._model.;


    }

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

      Provider.of<CustomerProvider>(context,listen: false).getCategoryList(context);

      if(widget.model!=null){
        getDataForUpdate();
      }

      // proposed_fee.text=widget.model!.proposedFee.toString();
    });
  }
  errorLoader(String message){
    showDialog(
      context: context,

      builder: (BuildContext context) {
        return Dialog(
          child:  SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [


                    Text(message),
                  ],
                ),
                spacer(10),
                InkWell(
                    onTap: ()=>Navigator.pop(context),
                    child: defaultButton(100, 'Ok'))
                
              ],
            ),
          ),
        );
      },
    );
  }
  Widget selectedDateTime(){
    return Consumer<AppointmentProvider>(

        builder: (context, snapshot,child) {
          return Padding(
            padding:const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10)
              ),

            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar("Enquiry", [], context),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
            children: [

              widget.model!=null?Container():  spacer(10),
              widget.model!=null?Container():    Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                    builder: (context, provider, child) {
                  return DropdownButtonFormField(
                    validator: (val){
                      if(val==null || val==""){
                        return "Please select Client";
                      }
                    },
                    value: provider.selectedCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration:
                        defaultDecoration("Select Client", "Select Client"),
                    items: provider.customerList
                        .map((e) => DropdownMenuItem<CustomerModel>(
                            value: e, child: Text(e.name,style:const TextStyle(color: Colors.pinkAccent))))
                        .toList(),
                    onChanged: (CustomerModel? value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      provider.setDropDownValue(value!);
                    },
                  );
                }),
              ),
              widget.model!=null?Container():  InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, customers);
                  },
                  child: const Text(
                    "Not listed?. add here",
                    style: TextStyle(color: Colors.blue),
                  )),
              spacer(10),

              Padding(
                padding:  const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                  builder: (context,snap,child){
                    return DropdownButtonFormField(
                      validator: (val){
                        if(val==null || val==""){
                          return "Please select source";
                        }
                      },
                      value: snap.selectedLeadSource,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration:
                      defaultDecoration("Select Lead source", "Select source"),
                      items: snap.leadSource
                          .map((e) => DropdownMenuItem(
                          value: e, child: Text(e,style:const TextStyle(color: Colors.pinkAccent))))
                          .toList(),
                      onChanged: (String? value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        snap.setLeadSource(value!);
                      },
                    );
                  },
                ),
              ),
            Padding(
                padding:  const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                  builder: (context,snap,child){
                    return DropdownButtonFormField(
                      validator: (val){
                        if(val==null || val==""){
                          return "Please select status";
                        }
                      },
                      value: snap.selectedLeadStatus,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration:
                      defaultDecoration("Select Lead status", "Select status"),
                      items: snap.leadStatus
                          .map((e) => DropdownMenuItem(
                          value: e, child: Text(e,style:const TextStyle(color: Colors.pinkAccent))))
                          .toList(),
                      onChanged: (String? value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        snap.setSelectedLeadStatus(value!);
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding:  const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Consumer<CustomerProvider>(
                builder: (context,snap,child){
                  return DropdownButtonFormField(
                    validator: (val){
                      if(val==null || val==""){
                        return "Please select type";
                      }
                    },
                    value: snap.selectedLeadType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration:
                    defaultDecoration("Select Lead type", "Select type"),
                    items: snap.leadType
                        .map((e) => DropdownMenuItem(
                        value: e, child: Text(e,style:const TextStyle(color: Colors.pinkAccent))))
                        .toList(),
                    onChanged: (String? value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      snap.setSelectedLeadType(value!);
                    },
                  );
                },
              ),
            ),




              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //   child: DropdownButtonFormField(
              //     // Initial Value
              //     value: refferd,
              //     decoration: InputDecoration(
              //         labelText: "Referred By",
              //         floatingLabelBehavior: FloatingLabelBehavior.auto,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(15))),
              //     // Down Arrow Icon
              //     icon: const Icon(Icons.keyboard_arrow_down),

              //     // Array list of items
              //     items: staffs.map((String items) {
              //       return DropdownMenuItem(
              //         value: items,
              //         child: Text(items),
              //       );
              //     }).toList(),
              //     // After selecting the desired option,it will
              //     // change button value to selected value
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         refferd = newValue!;
              //       });
              //     },
              //   ),
              // ),,

              spacer(10),


            columnUserTextFields('Project type', 'type', TextInputType.name, type),
              columnUserTextFields('Expense Source', 'Source', TextInputType.name, source),

              spacer(10),
              InkWell(
                onTap: (){
                  var ap=Provider.of<CustomerProvider>(context,listen: false);
                  EnquiryModel model=EnquiryModel(leadSoruce: ap.selectedLeadSource, projectType: '', leadStatus: ap.selectedLeadSource, leadType: ap.selectedLeadType, expenseSource: '', customer: ap.selectedCategory!);
                  Provider.of<AppointmentProvider>(context,listen: false).addEnquiry(model, context);
                },
                  child: defaultButton(300, widget.model==null?'Add':'Update')),



              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //   child: DropdownButtonFormField(
              //     // Initial Value
              //     value: doctorSel,
              //     decoration: InputDecoration(
              //         labelText: "Initial consultant",
              //         floatingLabelBehavior: FloatingLabelBehavior.auto,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(15))),
              //     // Down Arrow Icon
              //     icon: const Icon(Icons.keyboard_arrow_down),

              //     // Array list of items
              //     items: doctors.map((String items) {
              //       return DropdownMenuItem(
              //         value: items,
              //         child: Text(items),
              //       );
              //     }).toList(),
              //     // After selecting the desired option,it will
              //     // change button value to selected value
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         doctorSel = newValue!;
              //       });
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //   child: DropdownButtonFormField(
              //     // Initial Value
              //     value: doctorSel,
              //     decoration: InputDecoration(
              //         labelText: "Main consultant",
              //         floatingLabelBehavior: FloatingLabelBehavior.auto,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(15))),
              //     // Down Arrow Icon
              //     icon: const Icon(Icons.keyboard_arrow_down),

              //     // Array list of items
              //     items: doctors.map((String items) {
              //       return DropdownMenuItem(
              //         value: items,
              //         child: Text(items),
              //       );
              //     }).toList(),
              //     // After selecting the desired option,it will
              //     // change button value to selected value
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         doctorSel = newValue!;
              //       });
              //     },
              //   ),
              // ),




              spacer(20),
            ],
          ),
        ),
      ),
    );

  }

  Widget notes(String label, String hint, TextInputType keyboard,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter value for $hint";
          }
          return null;
        },
        controller: controller,
        keyboardType: keyboard,
        maxLines: 3,
        onChanged: (val){




        },

        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: whiteColor,
              fontSize: 13,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint,
            hintStyle: const TextStyle(color: textColor),
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30))),
      ),
    );
  }

  Widget proposedFee(String label, String hint, TextInputType keyboard,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter value for $hint";
          }
          return null;
        },
        controller: controller,
        keyboardType: keyboard,
        onChanged: (val){




        },
        enabled: false,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: whiteColor,
              fontSize: 13,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint,
            hintStyle: const TextStyle(color: textColor),
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30))),
      ),
    );
  }
  Widget customerFee(String label, String hint, TextInputType keyboard,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        validator: (value) {

          return null;
        },
        controller: controller,
        keyboardType: keyboard,
        onChanged: (val){




        },
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: whiteColor,
              fontSize: 13,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint,
            hintStyle: const TextStyle(color: textColor),
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30))),
      ),
    );
  }
  Widget amountPaid(String label, String hint, TextInputType keyboard,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        validator: (value) {

          return null;
        },
        controller: controller,
        keyboardType: keyboard,
        onChanged: (val){

        },
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: whiteColor,
              fontSize: 13,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint,
            hintStyle: const TextStyle(color: textColor),
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30))),
      ),
    );
  }

  Widget dueAmount(String label, String hint, TextInputType keyboard,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        validator: (value) {

          return null;
        },
        enabled: false,
        controller: controller,
        keyboardType: keyboard,

        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: whiteColor,
              fontSize: 13,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint,
            hintStyle: const TextStyle(color: textColor),
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
            disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30))),
      ),
    );
  }
}

Widget dateFiled(String label, String hint, TextInputType keyboard,
    TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please select value for $hint";
        }
        return null;
      },
      enabled: false,
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: whiteColor,
            fontSize: 13,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hint,
          hintStyle: const TextStyle(color: textColor),
          filled: true,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade500, width: 1)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 1)),
          disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30))),
    ),
  );
}

class HeadText extends StatelessWidget {
  final String txt;
  const HeadText({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(txt,style: const TextStyle(color: Colors.white,fontSize: 20),),),
    );
  }
}
