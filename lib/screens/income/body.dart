import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
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
      Provider.of<IncomeProvider>(context, listen: false).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Income', [], context),
      body: Consumer<IncomeProvider>(builder: (context, snapshot, child) {
        return snapshot.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.incomeList.length,
                itemBuilder: (_, index) {
                  return IncomeListItem(model: snapshot.incomeList[index]);
                },
              );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // bottomNavigationBar: const BottomAppBar(
      //   color: blackColor,
      //   child: SizedBox(
      //     width: double.infinity,
      //     height: 50,
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
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
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      model.project.name,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Project Status ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: model.project.status,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
