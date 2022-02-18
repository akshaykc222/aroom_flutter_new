import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/enquiry/componets/enquiry_detail.dart';

import 'package:seed_sales/screens/enquiry/model/appointmentsmodel.dart';
import 'package:seed_sales/screens/enquiry/model/timeslotmodel.dart';
import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:seed_sales/screens/services/componets/order.dart';
import 'package:uuid/uuid.dart';

import '../../componets.dart';
import '../../constants.dart';

class Enquiry extends StatefulWidget {
  const Enquiry({Key? key}) : super(key: key);

  @override
  State<Enquiry> createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<AppointmentProvider>(context, listen: false)
          .getEnquiry(context);

    });
  }

  showFilterAndSortSheet() async {
    var p = Provider.of<AppointmentProvider>(context, listen: false);
    p.clearTempList();
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: items.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: null,
          onConfirm: (List<String> values) {

          },
          initialChildSize: 0.8,
          maxChildSize: 0.8,
        );
      },
    );
  }

  bool tap = false;
  List<String> selectedItem = [];
  List<String> sortItemList = [
    "Sort by ascending booking date",
    "Sort by descending booking date"
  ];
  var items = [
    'enquired',
    'advance paid',
    'completed',
    'canceled',
    'remove filters'
  ];
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: appBar("Appointments", [], context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // columUserTextFileds("search","",TextInputType.name,TextEditingController()),
            spacer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    var p = Provider.of<AppointmentProvider>(context,
                        listen: false);
                    await showModalBottomSheet(
                      isScrollControlled:
                          true, // required for min/max child size
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      builder: (ctx) {
                        return Wrap(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Sort',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.topCenter,
                                        margin: const EdgeInsets.all(4),
                                        child: ChoiceChip(
                                          backgroundColor:
                                              Colors.lightBlueAccent.shade200,
                                          label: const Text(
                                            "Sort by booking date ascending",
                                            style: TextStyle(color: whiteColor),
                                          ),
                                          selected: true,
                                          disabledColor: Colors.black,
                                          onSelected: (bool value) {

                                            Navigator.pop(context);
                                          },
                                          pressElevation: 20,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        margin: const EdgeInsets.all(4),
                                        child: ChoiceChip(
                                          backgroundColor:
                                              Colors.lightBlueAccent.shade200,
                                          label: const Text(
                                              "Sort by booking date descending",
                                              style:
                                                  TextStyle(color: whiteColor)),
                                          selected: true,
                                          onSelected: (bool value) {

                                            Navigator.pop(context);
                                          },
                                          pressElevation: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          )
                        ]);
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [Text("sort by"), Icon(Icons.sort)],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    showFilterAndSortSheet();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text("Filter"),
                        Icon(Icons.filter_list_alt)
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            spacer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(8.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, order);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            Text('Add Enquiry')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<AppointmentProvider>(builder: (context, snapshot, child) {
              print(snapshot.tempList.length);
              return ListView.builder(
                  itemCount: snapshot.tempList.isEmpty
                      ? snapshot.enquiryList.length
                      : snapshot.tempList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return EnquiryCustomer(
                      model: snapshot.tempList.isEmpty
                          ? snapshot.enquiryList[index]
                          : snapshot.tempList[index],
                    );
                  });
            })
          ],
        ),
      ),
    );
  }
}

class EnquiryCustomer extends StatefulWidget {
  final EnquiryModel model;
  const EnquiryCustomer({Key? key, required this.model}) : super(key: key);

  @override
  State<EnquiryCustomer> createState() => _EnquiryCustomerState();
}

class _EnquiryCustomerState extends State<EnquiryCustomer> {

  @override
  void initState() {


    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.model.customer.name),
    );
  }
}

class BookDateCard extends StatelessWidget {
  final String head;
  final String tail;
  const BookDateCard({Key? key, required this.head, required this.tail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          head,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
        ),
        Text(
          tail,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
