import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/products/model/product_model.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';
import 'package:seed_sales/screens/subcategory/models/sub_category.dart';
import 'package:seed_sales/screens/subcategory/provider/sub_category_provider.dart';
import 'package:seed_sales/screens/tax/model/taxmodel.dart';
import 'package:seed_sales/screens/tax/provider/tax_provider.dart';

import '../../constants.dart';
import '../../sizeconfig.dart';
import 'componets/categrory.dart';
import 'componets/products.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Treatment", [], context),
      body: Stack(children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: const [
              CategorySelection(),
              ProductDetails(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: defaultButton(
                    MediaQuery.of(context).size.width * 0.6, add)))
      ]),
    );
  }
}

class AddTreatments extends StatefulWidget {
  final ProjectModel? model;
  const AddTreatments({Key? key, this.model}) : super(key: key);

  @override
  _AddTreatmentsState createState() => _AddTreatmentsState();
}

class _AddTreatmentsState extends State<AddTreatments> {
  final titleController = TextEditingController();
  final purchaseController = TextEditingController();

  final estimateController = TextEditingController();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final remarkController = TextEditingController();
  String image = "";
  String service = "Supervising";
  List<String> serItems = ["Supervising", "Quotation based"];
  DateTime? starDate;
  DateTime? endDate;

  _upload() {
    print('===============uploading==================');

    SubCategoryModel? subID = Provider
        .of<SubCategoryProvider>(context, listen: false)
        .selectedCategory;
    if (subID == null) {
      print('===============uploading failed==================');
      errorLoader('select sub category');
    } else if (Provider
        .of<CustomerProvider>(context, listen: false)
        .selectedCategory == null) {
      print('===============uploading failed==================');
      errorLoader('select client');
    }else if(remarkController.text.isEmpty){
      errorLoader('Please add remarks');
  } else if(estimateController.text.isEmpty){
      errorLoader('please add estimate amount');
    }else if(endDate==null){
      errorLoader('select deadline');
    }else if(starDate==null){
      errorLoader('select start date');
    }
    else {
      loader(
          widget.model == null ? 'Updating.please wait' : 'adding please wait');


      ProjectModel model = ProjectModel(

        id: widget.model == null ? null : widget.model!.id,
        name: titleController.text,


        category: Provider
            .of<SubCategoryProvider>(context, listen: false)
            .selectedCategory!,
        type: service,
        startDate: starDate!,
        deadLine: endDate!,
        estProjectValue: double.parse(estimateController.text),
        remarks: remarkController.text,
        client: Provider
            .of<CustomerProvider>(context, listen: false)
            .selectedCategory!,
      );
      widget.model == null ? Provider.of<ProjectProvider>(
          context, listen: false)
          .add(model, context) : Provider.of<ProjectProvider>(
          context, listen: false)
          .updateFun(context, model);
      Navigator.pop(context);
    }


  }

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      try {

        titleController.text = widget.model!.name;
        remarkController.text=widget.model!.remarks;
        endDate=widget.model!.deadLine;
        starDate=widget.model!.startDate;
        startDateController.text=DateFormat('dd-MM-yyyy').format(starDate!);
        endDateController.text=DateFormat('dd-MM-yyyy').format(endDate!);
        estimateController.text=widget.model!.estProjectValue.toString();
      } catch (e) {
        print('eroor');
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      CustomerProvider c=Provider.of<CustomerProvider>(context,listen: false);
      c.getCategoryList(context);
      if(widget.model!=null){
        c.setDropDownValue(widget.model!.client);

      }

    });
  }

  Future<void> _showStartPicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      setState(() {
        starDate=picked;
        startDateController.text=DateFormat("dd-MM-yyyy").format(starDate!);
      });
    }
  }
  Future<void> _showEndPicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: starDate?? DateTime.now(),
        firstDate:starDate??  DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      setState(() {
        endDate=picked;
        endDateController.text=DateFormat("dd-MM-yyyy").format(endDate!);
      });
    }
  }
  loader(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 20,
                ),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  errorLoader(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Error',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
                ),
                Text(message,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 18),),
                spacer(10),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultButton(100, "Ok"),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            widget.model != null
                ? headingText("Update Project")
                : headingText("Add Project"),
            columUserTextFiledsBlack(
                "Enter Title", "Title", TextInputType.name, titleController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: DropdownButtonFormField(
                // Initial Value
                value: service,
                decoration: InputDecoration(
                    labelText: "Type",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: serItems.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    service = newValue!;
                  });
                },
              ),
            ),
            const CategorySelection(),

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            //   child:
            //   Consumer<TaxProvider>(builder: (context, provider, child) {
            //     return DropdownButtonFormField(
            //       value: provider.selectedBusiness,
            //       icon: const Icon(Icons.keyboard_arrow_down),
            //       decoration: InputDecoration(
            //           labelText: "Tax",
            //           floatingLabelBehavior: FloatingLabelBehavior.auto,
            //           border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(15))),
            //       items: provider.businessList
            //           .map((e) => DropdownMenuItem<TaxModel>(
            //           value: e, child: Text(e.name)))
            //           .toList(),
            //       onChanged: (TaxModel? value) {
            //         setState(() {
            //           provider.setDropDownValue(value!);
            //         });
            //       },
            //     );
            //   }),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:1,horizontal: 25),
              child: SizedBox(
                height: 70,
                child: Consumer<CustomerProvider>(

                  builder: (context, snapshot,child) {
                    return DropdownSearch<CustomerModel>(
                        mode: Mode.MENU,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                          )
                        ),
                        items: snapshot.customerList,
                        label: "Client",
                        hint: "Select client",
                        itemAsString: (CustomerModel? m)=>m!.name,
                        onChanged: (value){
                          snapshot.setDropDownValue(value);
                        },
                        selectedItem: snapshot.selectedCategory
                    );
                  }
                ),
              ),
            ),
           InkWell(
                    onTap: () {
                      _showStartPicker();
                    },
                    child: dateField("Enter Start date", "Start date",
                        TextInputType.datetime, startDateController),
                  )
               ,
            InkWell(
              onTap: () {
                _showEndPicker();
              },
              child: dateField("Enter dead line", "dead line",
                  TextInputType.datetime, endDateController),
            ),
            columUserTextFiledsBlack(
                "Estimate  amount", "Estimate", const TextInputType.numberWithOptions(decimal: true), estimateController),
            columUserTextFiledsBlack(
                "Enter remarks", "remarks", TextInputType.name, remarkController),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'Product Images',
            //     style: TextStyle(
            //         color: blackColor,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18),
            //   ),
            // ),
            // InkWell(
            //   onTap: () async {
            //     FilePickerResult? result =
            //         await FilePicker.platform.pickFiles(type: FileType.image);
            //
            //     if (result != null) {
            //       showDialog(
            //         context: context,
            //         barrierDismissible: false,
            //         builder: (BuildContext context) {
            //           return Dialog(
            //             child: SizedBox(
            //               height: 100,
            //               child: Row(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisSize: MainAxisSize.min,
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: const [
            //                   CircularProgressIndicator(),
            //                   SizedBox(
            //                     width: 20,
            //                   ),
            //                   Text("Loading.."),
            //                 ],
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //       File file = File(result.files.single.path!);
            //       FirebaseStorage storage = FirebaseStorage.instance;
            //       Reference ref =
            //           storage.ref().child("image" + DateTime.now().toString());
            //       UploadTask uploadTask = ref.putFile(file);
            //       uploadTask.then((res) async {
            //         String url = await res.ref.getDownloadURL();
            //         debugPrint(url);
            //         setState(() {
            //           image = url;
            //         });
            //
            //         Navigator.pop(context);
            //       });
            //     } else {
            //       // User canceled the picker
            //     }
            //   },
            //   child: image == ""
            //       ? SizedBox(
            //           width: 50,
            //           height: 50,
            //           child: Container(
            //             color: Colors.grey,
            //             child: const Center(
            //               child: Icon(Icons.add_a_photo_outlined),
            //             ),
            //           ),
            //         )
            //       : SizedBox(
            //           width: 150,
            //           height: 150,
            //           child: Image.network(image),
            //         ),
            // ),
            spacer(10),
            // Visibility(
            //     visible: !isService, child: columUserTextFileds("Duration")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {



                          _upload();
                    },
                    child: defaultButton(SizeConfig.screenWidth! * 0.5,
                        widget.model != null ? "update" : add)),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      cancel,
                      style: TextStyle(color: blackColor),
                    ))
              ],
            ),
            spacer(10)
          ],
        ),
      ),
    );
  }
}

Widget duration(String label, String hint, TextInputType keyboard,
    TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
    child: TextFormField(
      validator: (vval) {
        if (vval!.isEmpty) {
          return null;
        }
      },
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: blackColor),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: blackColor),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hint,
          hintStyle: const TextStyle(color: blackColor),
          filled: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: blackColor,
              width: 2.0,
            ),
          ),
          disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: blackColor)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: blackColor))),
    ),
  );
}

Widget dateField(String label, String hint, TextInputType keyboard,
    TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: blackColor),
      decoration: InputDecoration(
          labelText: label,
          enabled: false,
          labelStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.normal, color: blackColor),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hint,
          hintStyle: const TextStyle(color: blackColor),
          filled: true,
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: blackColor,
              width: 0.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: blackColor,
              width: 0.5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: blackColor,
              width: 0.5,
            ),
          )),
    ),
  );
}
