import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/screens/products/body.dart';
import 'package:seed_sales/screens/products/model/product_model.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';

import '../../../componets.dart';
import '../../../constants.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<ProjectProvider>(context, listen: false)
          .get(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    void showAlertDelete1(BuildContext _context, {ProjectModel? model}) {
      Navigator.push(context, MaterialPageRoute(builder: (_)=>model != null
          ? AddTreatments(
        model: model,
      )
          : const AddTreatments()));
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Text('Projects'),
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<ProjectProvider>(builder: (context, snapshot, child) {
        return snapshot.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.productList.length,

                itemBuilder: (_, index) {
                  return ProductListTile(model: snapshot.productList[index]);
                });
      }),
      // bottomNavigationBar: const BottomAppBar(
      //   color: blackColor,
      //   child: SizedBox(
      //     width: double.infinity,
      //     height: 50,
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          showAlertDelete1(
            context,
          );
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProductListTile extends StatelessWidget {
  final ProjectModel model;
  const ProductListTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var p=Provider.of<ProjectProvider>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.name,style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold,color: Colors.black),),
                  RichText(
                    text: TextSpan(
                      text: 'Est. Value ',
                      style: DefaultTextStyle.of(context).style,
                      children:  <TextSpan>[
                        TextSpan(text: '${model.estProjectValue}', style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent)),

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
                     text: 'Client Name ',
                     style: DefaultTextStyle.of(context).style,
                     children:  <TextSpan>[
                       TextSpan(text: model.client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
                 RichText(
                   text: TextSpan(
                     text: 'Phone ',
                     style: DefaultTextStyle.of(context).style,
                     children:  <TextSpan>[
                       TextSpan(text: model.client.phone, style: const TextStyle(fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
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
                      text: 'Start Date ',
                      style: DefaultTextStyle.of(context).style,
                      children:  <TextSpan>[
                        TextSpan(text: DateFormat('dd-MM-yyyy').format(model.startDate), style: const TextStyle(fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Dead Line ',
                      style: DefaultTextStyle.of(context).style,
                      children:  <TextSpan>[
                        TextSpan(text: DateFormat('dd-MM-yyyy').format(model.deadLine), style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent)),

                      ],
                    ),
                  ),
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
                      text: 'Status ',
                      style: DefaultTextStyle.of(context).style,
                      children:  <TextSpan>[
                        TextSpan(text: model.status, style: TextStyle(fontWeight: FontWeight.bold,color: model.status=="COMPLETED"?Colors.green:Colors.black)),

                      ],
                    ),
                  ),
                  model.status=="ON GOING"?     RichText(
                    text: TextSpan(
                      text: 'Remaining Days ',
                      style: DefaultTextStyle.of(context).style,
                      children:  <TextSpan>[
                        TextSpan(text: '${model.startDate.difference(model.deadLine).inDays}', style: TextStyle(fontWeight: FontWeight.bold,color: model.startDate.difference(model.deadLine).inDays<10?Colors.red:Colors.black)),

                      ],
                    ),
                  ):Container(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: (){
                  p.delete(model, context);
                },
                icon: const Icon(Icons.delete)),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> AddTreatments(
                    model: model,
                  )));
                },
                icon: const Icon(Icons.edit)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
