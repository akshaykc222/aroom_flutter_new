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
  const IncomeAdd({Key? key}) : super(key: key);

  @override
  State<IncomeAdd> createState() => _IncomeAddState();
}

class _IncomeAddState extends State<IncomeAdd> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerProvider>(context,listen: false).getCategoryList(context);
      Provider.of<ProjectProvider>(context,listen: false).get(context: context);

    });
  }
  final amountController=TextEditingController();
  final narrationController=TextEditingController();
  final formKey=GlobalKey<FormState>();
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
              const Text('Add Income',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              spacer(10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 25),
                child: Consumer<CustomerProvider>(

                  builder: (context, snapshot,child) {
                    return snapshot.loading?const Center(child: CircularProgressIndicator(),): DropdownSearch<CustomerModel>(
                      items: snapshot.customerList,
                      showSearchBox: true,
                      onChanged: (CustomerModel? model){
                        snapshot.setDropDownValue(model);
                      },
                      popupTitle:const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Text('Select Client',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      dropdownSearchDecoration: defaultDecoration('Client','Client'),
                      selectedItem: snapshot.selectedCategory,
                      itemAsString: (CustomerModel? m)=>m!.name,
                    );
                  }
                ),
              ),
              spacer(10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 25),
                child: Consumer<ProjectProvider>(

                    builder: (context, snapshot,child) {
                      return snapshot.productList.isEmpty?const Center(child: Text('no projects found',style: TextStyle(color: Colors.white),),): DropdownSearch<ProjectModel>(
                        items: snapshot.productList,
                        showSearchBox: true,
                        onChanged: (ProjectModel? model){
                          snapshot.changeSelectedModel(model);
                        },
                        dropdownSearchBaseStyle: const TextStyle(color: Colors.white),
                        popupTitle:const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child:  Text('Select project',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        dropdownSearchDecoration: defaultDecoration('Project','Project'),
                        selectedItem: snapshot.selectedModel,
                        itemAsString: (ProjectModel? m)=>m!.name,
                      );
                    }
                ),
              ),
              spacer(10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 25),
                child: Consumer<IncomeProvider>(

                    builder: (context, snapshot,child) {
                      return  DropdownSearch<String>(
                        items: snapshot.paymentMode,

                        onChanged: (String? model){
                          snapshot.changePaymentMode(model!);
                        },
                        mode: Mode.MENU,
                        dropdownSearchDecoration: defaultDecoration('Payment mode','Payment mode'),
                        selectedItem: snapshot.selectedPaymentMode,
                      );
                    }
                ),
              ),
              columUserTextFiledsBlack('Income amount', 'Income amount', const TextInputType.numberWithOptions(decimal: true), amountController),
              columUserTextFiledsBlack('Narration', 'Narration', TextInputType.multiline,narrationController),
              InkWell(
            onTap:(){
              if(formKey.currentState!.validate()){
                // Provider.of<CustomerProvider>(context,
                Provider.of<IncomeProvider>(context,listen: false).add(context: context, body: IncomeModel(amount: double.parse(amountController.text), narration: narrationController.text, client: Provider.of<CustomerProvider>(context,listen: false).selectedCategory!, project: Provider.of<ProjectProvider>(context,listen: false).selectedModel!));
              }

              },
              child:Consumer<IncomeProvider>(

                builder: (context, snapshot,child) {
                  return snapshot.loading?const Center(child: CircularProgressIndicator(),): defaultButton(300, 'addd');
                }
              )
            )


            ],
          ),
        ),
      ),
    );
  }
}
