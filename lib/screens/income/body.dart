import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/income/componets/add.dart';
import 'package:seed_sales/screens/income/model/income_model.dart';
import 'package:seed_sales/screens/income/provider/income_provider.dart';


class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<IncomeProvider>(context,listen: false).get();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Income', [], context),
      body: Consumer<IncomeProvider>(builder: (context, snapshot, child) {
        return snapshot.loading?const Center(child: CircularProgressIndicator(color: Colors.white,),): ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,

          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.incomeList.length,
          itemBuilder: (_, index) {
            return IncomeListItem(model: snapshot.incomeList[index]);
          },);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        color: blackColor,
        child: SizedBox(
          width: double.infinity,
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightBlack,
        onPressed: () {
          //
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const IncomeAdd()));
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
      // floatingActionButton: ,
    );
  }
}
class IncomeListItem extends StatelessWidget {
  final IncomeModel model;
  const IncomeListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: black90,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.project.name,style: const TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 18),),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('project ${model.project.name}',style: const TextStyle(color: textColor),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('income ${model.amount}',style: const TextStyle(color: textColor),),
            ),
          ],
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset('assets/icons/edit.svg',color: Colors.white,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset('assets/icons/trash.svg',color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
