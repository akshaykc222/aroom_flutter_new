import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/screens/enquiry/model/appointmentsmodel.dart';
import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';
import 'package:seed_sales/screens/services/componets/order.dart';

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
          onConfirm: (List<String> values) {},
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
      appBar: appBar("Enquiry", [], context),
      body: Consumer<AppointmentProvider>(
        builder: (context, snap, child) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.enquiryList.length,
              itemBuilder: (context, index) {
                return EnquiryCustomer(model: snap.enquiryList[index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const OrderProducts()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EnquiryCustomer extends StatelessWidget {
  final EnquiryModel model;
  const EnquiryCustomer({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.customer.name,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Phone ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: model.customer.phone,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Project Type ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: model.projectType,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderProducts(
                                    model: model,
                                  )));
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Lead Type ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: model.leadType,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<AppointmentProvider>(context, listen: false)
                          .deleteEnquiry(context, model);
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Lead Status ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: model.leadStatus,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
