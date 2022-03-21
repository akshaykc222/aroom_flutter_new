import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/screens/customers/components/customer_list.dart';
import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/enquiry/model/appointmentsmodel.dart';
import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';
import 'package:seed_sales/screens/user/provider/users_provider.dart';

class OrderProducts extends StatefulWidget {
  final EnquiryModel? model;
  const OrderProducts({Key? key, this.model}) : super(key: key);

  @override
  _OrderProductsState createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {
  final type = TextEditingController();
  final source = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? bookDate;
  TimeOfDay? bookTime;

  getDataForUpdate() async {
    // actual_fee.text=widget.model!.customerFee.toString();
    var p = Provider.of<CustomerProvider>(context, listen: false);
    var a = Provider.of<UserProviderNew>(context, listen: false);
    var pr = Provider.of<ProjectProvider>(context, listen: false);

    var psd = Provider.of<AppointmentProvider>(context, listen: false);

    p.setDropDownValue(widget.model!.customer);
    p.setLeadSource(widget.model!.leadSoruce);
    p.setSelectedLeadType(widget.model!.leadType);
    p.setSelectedLeadStatus(widget.model!.leadStatus);
    setState(() {
      service = widget.model!.projectType;
    });
  }

  @override
  void initState() {
    if (widget.model != null) {
      log("selected status ${widget.model!.toJson()}");
      // name.text=widget._model.;

    }

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerProvider>(context, listen: false)
          .getCategoryList(context);
      Provider.of<AppointmentProvider>(context, listen: false).stopLoading();

      if (widget.model != null) {
        getDataForUpdate();
      }

      // proposed_fee.text=widget.model!.proposedFee.toString();
    });
  }

  errorLoader(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                  ],
                ),
                spacer(10),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: defaultButton(100, 'Ok'))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectedDateTime() {
    return Consumer<AppointmentProvider>(builder: (context, snapshot, child) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  String service = "SUPERVISING";
  List<String> serItems = ["SUPERVISING", "QUOTATION BASED"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar("Enquiry", [], context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                    builder: (context, provider, child) {
                  return DropdownSearch<CustomerModel>(
                    validator: (val) {
                      if (val == null || val == "") {
                        return "Please select Client";
                      }
                    },
                    enabled: widget.model == null,
                    itemAsString: (CustomerModel? m) => m!.name,
                    selectedItem: provider.selectedCategory,
                    dropdownSearchDecoration:
                        defaultDecoration("Select Client", "Select Client"),
                    items: provider.customerList,
                    onChanged: (CustomerModel? value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      provider.setDropDownValue(value!);
                    },
                  );
                }),
              ),
              widget.model != null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CustomerForm()));
                      },
                      child: const Text(
                        "Not listed?. add here",
                        style: TextStyle(color: Colors.blue),
                      )),
              spacer(10),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                  builder: (context, snap, child) {
                    return DropdownSearch<String>(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "Please select source";
                        }
                      },

                      selectedItem: snap.selectedLeadSource,
                      // icon: const Icon(Icons.keyboard_arrow_down),
                      dropdownSearchDecoration: defaultDecoration(
                          "Select Lead source", "Select source"),
                      items: snap.leadSource,
                      onChanged: (String? value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        snap.setLeadSource(value!);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                  builder: (context, snap, child) {
                    return DropdownSearch<String>(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "Please select status";
                        }
                      },
                      selectedItem: snap.selectedLeadStatus,
                      dropdownSearchDecoration: defaultDecoration(
                          "Select Lead status", "Select status"),
                      items: snap.leadStatus,
                      onChanged: (String? value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        snap.setSelectedLeadStatus(value!);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<CustomerProvider>(
                  builder: (context, snap, child) {
                    return DropdownSearch<String>(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "Please select type";
                        }
                      },
                      selectedItem: snap.selectedLeadType,
                      dropdownSearchDecoration:
                          defaultDecoration("Select Lead type", "Select type"),
                      items: snap.leadType,
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

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Consumer<ProjectProvider>(
                  builder: (context, snap, child) {
                    return DropdownSearch<String>(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "Please select type";
                        }
                      },
                      selectedItem: service,
                      mode: Mode.MENU,
                      dropdownSearchDecoration: defaultDecoration(
                          "Select Project type", "Select Project type"),
                      items: serItems,
                      onChanged: (String? value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        service = value!;
                      },
                    );
                  },
                ),
              ),
              columnUserTextFields(
                  'Expense Source', 'Source', TextInputType.name, source),

              spacer(10),
              InkWell(onTap: () {
                var ap = Provider.of<CustomerProvider>(context, listen: false);
                EnquiryModel model = EnquiryModel(
                    id: widget.model?.id,
                    leadSoruce: ap.selectedLeadSource,
                    projectType: service,
                    leadStatus: ap.selectedLeadSource,
                    leadType: ap.selectedLeadType,
                    expenseSource: source.text,
                    customer: ap.selectedCategory!);
                var p =
                    Provider.of<AppointmentProvider>(context, listen: false);
                widget.model == null
                    ? p.addEnquiry(model, context)
                    : p.updateEnquiry(context, model);
              }, child: Consumer<AppointmentProvider>(
                  builder: (context, snapshot, child) {
                return snapshot.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : defaultButton(
                        300, widget.model == null ? 'Add' : 'Update');
              })),

              spacer(20),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadText extends StatelessWidget {
  final String txt;
  const HeadText({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
