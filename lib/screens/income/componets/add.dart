import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/income/model/income_model.dart';
import 'package:seed_sales/screens/income/provider/income_provider.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';

class IncomeAdd extends StatefulWidget {
  final IncomeModel? model;
  const IncomeAdd({Key? key, this.model}) : super(key: key);

  @override
  State<IncomeAdd> createState() => _IncomeAddState();
}

class _IncomeAddState extends State<IncomeAdd> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerProvider>(context, listen: false)
          .getCategoryList(context);
      Provider.of<ProjectProvider>(context, listen: false)
          .get(context: context);
    });
  }

  final amountController = TextEditingController();
  final narrationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Income', [], context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text(
                'Add Income',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              spacer(10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: Consumer<CustomerProvider>(
                    builder: (context, snapshot, child) {
                  return snapshot.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          height: 70,
                          child: DropdownSearch<CustomerModel>(
                            items: snapshot.customerList,
                            showSearchBox: true,
                            onChanged: (CustomerModel? model) {
                              snapshot.setDropDownValue(model);
                            },
                            popupTitle: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Select Client',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            dropdownSearchDecoration:
                                defaultDecoration('Client', 'Client'),
                            selectedItem: snapshot.selectedCategory,
                            itemAsString: (CustomerModel? m) => m!.name,
                          ),
                        );
                }),
              ),
              spacer(10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: Consumer<ProjectProvider>(
                    builder: (context, snapshot, child) {
                  return snapshot.productList.isEmpty
                      ? const Center(
                          child: Text(
                            'no projects found',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox(
                          height: 70,
                          child: DropdownSearch<ProjectModel>(
                            items: snapshot.productList,
                            showSearchBox: true,
                            onChanged: (ProjectModel? model) {
                              snapshot.changeSelectedModel(model);
                            },
                            dropdownSearchBaseStyle:
                                const TextStyle(color: Colors.white),
                            popupTitle: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Select project',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            dropdownSearchDecoration:
                                defaultDecoration('Project', 'Project'),
                            selectedItem: snapshot.selectedModel,
                            itemAsString: (ProjectModel? m) => m!.name,
                          ),
                        );
                }),
              ),
              spacer(10),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Payment',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              spacer(10),
              Consumer<ProjectProvider>(builder: (context, snapshot, child) {
                return snapshot.selectedModel == null
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            child: RichText(
                              text: TextSpan(
                                text: 'Project est value \t',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '\t ${snapshot.selectedModel?.estProjectValue}\t₹',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
              }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: Consumer<IncomeProvider>(
                    builder: (context, snapshot, child) {
                  return SizedBox(
                    height: 70,
                    child: DropdownSearch<String>(
                      items: snapshot.paymentMode,
                      onChanged: (String? model) {
                        snapshot.changePaymentMode(model!);
                      },
                      mode: Mode.MENU,
                      dropdownSearchDecoration:
                          defaultDecoration('Payment mode', 'Payment mode'),
                      selectedItem: snapshot.selectedPaymentMode,
                    ),
                  );
                }),
              ),
              columnUserTextFields(
                  'Income amount',
                  'Income amount',
                  const TextInputType.numberWithOptions(decimal: true),
                  amountController),
              columnUserTextFields('Narration', 'Narration',
                  TextInputType.multiline, narrationController,
                  required: true),
              spacer(20),
              widget.model != null
                  ? PaymentHistoryList(model: widget.model!.paymentHistory)
                  : Container(),
              Consumer<IncomeProvider>(builder: (context, snapshot, child) {
                return InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        // Provider.of<CustomerProvider>(context,
                        List<PaymentHistory> paymentHistoryList = [];
                        if (widget.model != null) {
                          paymentHistoryList
                              .addAll(widget.model!.paymentHistory);
                          paymentHistoryList.add(PaymentHistory(
                            amount: double.parse(amountController.text),
                            paymentMode: Provider.of<ProjectProvider>(context,
                                    listen: false)
                                .selectedStatus,
                            narration: narrationController.text,
                          ));
                        } else {
                          paymentHistoryList.add(PaymentHistory(
                            amount: double.parse(amountController.text),
                            paymentMode: Provider.of<ProjectProvider>(context,
                                    listen: false)
                                .selectedStatus,
                            narration: narrationController.text,
                          ));
                        }
                        snapshot.add(
                            context: context,
                            body: IncomeModel(
                                id: widget.model != null
                                    ? widget.model!.id
                                    : null,
                                client: Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .selectedCategory!,
                                project: Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .selectedModel!,
                                paymentHistory: paymentHistoryList));
                      }
                    },
                    child: snapshot.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : defaultButton(
                            300, widget.model == null ? 'Add' : 'Update'));
              })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentHistoryList extends StatelessWidget {
  final List<PaymentHistory> model;
  const PaymentHistoryList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            itemCount: model.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  '${model[index].amount}',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Payment Mode - ${model[index].paymentMode}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model[index].narration ?? ""),
                    )
                  ],
                ),
              );
            })
      ],
    );
  }
}
