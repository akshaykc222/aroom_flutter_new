import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/enquiry/model/timeslotmodel.dart';
import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';


    
class SelectDateAndTimeSlot extends StatefulWidget {
  final DateTime? bookDate;
  const SelectDateAndTimeSlot({Key? key, this.bookDate}) : super(key: key);

  @override
  State<SelectDateAndTimeSlot> createState() => _SelectDateAndTimeSlotState();
}

class _SelectDateAndTimeSlotState extends State<SelectDateAndTimeSlot> {
  DateTime? bookDate;
  final date = TextEditingController();
  Future<void> _showBookingPicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      setState(() {
        bookDate=picked;
        date.text = DateFormat("yyyy-MM-dd").format(picked);
       var p= Provider.of<AppointmentProvider>(context,listen: false);


      });
    }
  }
  @override
  void initState() {
    setState(() {
      if(widget.bookDate!=null){
        bookDate=widget.bookDate;
        date.text = DateFormat("yyyy-MM-dd").format(bookDate!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Select date and time slot',overflow: TextOverflow.fade,style: TextStyle(color: whiteColor),),backgroundColor: Colors.blue,),
      body: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  _showBookingPicker();
                },
                child: dateFiled(
                    "Booking date", "date", TextInputType.datetime, date),
              ),

            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ArgonButton(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              borderRadius: 5.0,
              color: Colors.blue,
              child: const Text(
                "Ok",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),
              ),
              loader: Container(
                padding: const EdgeInsets.all(10),
                child: const SpinKitRotatingCircle(
                  color: Colors.white,
                  // size: loaderWidth ,
                ),
              ),
              onTap: (startLoading, stopLoading, btnState) {
                var p=Provider.of<AppointmentProvider>(context,listen: false);

                DateTime? selectedDate=p.selectedBookDate;


              },
            ),
          ))
        ],
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
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Select date',
        labelText: 'Booking date' ,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:const BorderSide(color: Colors.black)
        )
      ),
    ),
  );
}
