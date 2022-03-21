import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/screens/expense/components/expense_add.dart';
import 'package:seed_sales/screens/expense/provider/expense_provider.dart';
import 'package:seed_sales/screens/income/model/income_model.dart';

import '../products/provider/products_provider.dart';

class Expense extends StatelessWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ExpenseProvider>(context, listen: false).get();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
      ),
      body: Consumer<ExpenseProvider>(builder: (context, snapshot, child) {
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
                itemCount: snapshot.expenseList.length,
                itemBuilder: (_, index) {
                  return ExpanseListItem(model: snapshot.expenseList[index]);
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ExpenseAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpanseListItem extends StatelessWidget {
  final IncomeModel model;
  const ExpanseListItem({Key? key, required this.model}) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Total Expense ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${Provider.of<ProjectProvider>(context, listen: false).getTotal(model)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ExpenseAdd(
                                      model: model,
                                    )));
                      },
                      icon: const Icon(Icons.edit)),
                  // IconButton(onPressed: (){}, icon: const Icon(Icons.de)),
                ],
              )
            ],
          ),
        ));
  }
}
