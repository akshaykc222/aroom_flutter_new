import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/componets.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/categories/models/categories_model.dart';
import 'package:seed_sales/screens/categories/provider/category_provider.dart';
import 'package:seed_sales/screens/subcategory/body.dart';

import 'package:seed_sales/screens/subcategory/models/sub_category.dart';
import 'package:seed_sales/screens/subcategory/provider/sub_category_provider.dart';

class CategorySelection extends StatefulWidget {
  final bool? update;
  const CategorySelection({Key? key,  this.update}) : super(key: key);

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  bool visible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if( widget.update==null){
        // Provider.of<CategoriesProvider>(context, listen: false).emptyDropdown();
        // Provider.of<SubCategoryProvider>(context, listen: false).emptyDropDown();
      }

      Provider.of<CategoriesProvider>(context, listen: false)
          .getCategoryList(context);
      // Provider.of<SubCategoryProvider>(context, listen: false)
      //     .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: visible,
          child: Column(
            children: [

              Padding(
                padding:
                    const EdgeInsets.only(top: 8, left: 25,right: 8,bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 70,
                      child: Consumer<CategoriesProvider>(
                          builder: (context, snapshot, child) {
                        return snapshot.loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : snapshot.categoryList.isEmpty
                                ? const Center(
                                    child: Text('no  category found'),
                                  )
                                : DropdownSearch<CategoriesModel>(
                                    // Initial Value
                                    selectedItem: snapshot.selectedCategory,
                                    mode: Mode.MENU,
                                    itemAsString: (CategoriesModel?  m)=>m!.name,
                                    dropdownSearchDecoration: InputDecoration(
                                        labelText: " Category",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15))),
                                    // Down Arrow Icon


                                    // Array list of items
                                    items: snapshot.categoryList,
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (CategoriesModel? newValue) {
                                      Provider.of<SubCategoryProvider>(context,
                                              listen: false)
                                          .get(context, newValue!.id!);
                                      Provider.of<SubCategoryProvider>(context,
                                              listen: false)
                                          .emptyDropDown();
                                      snapshot.setDropDownValue(newValue);
                                    },
                                  );
                      }),
                    ),
                    IconButton(onPressed: (){
                      showCategoryAdd(context);
                    }, icon: const Icon(Icons.add))
                  ],
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.only(top: 8, left: 25,right: 25,bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.7,
                      height: 70,
                      child: Consumer<SubCategoryProvider>(
                          builder: (context, snapshot, child) {
                            return snapshot.loading
                                ? const Center(
                              child: CircularProgressIndicator(),
                            )
                                : snapshot.subcategoryList.isEmpty? Center(child: InkWell(
                                onTap: (){
                                  CategoriesModel? model= Provider.of<CategoriesProvider>(context, listen: false).selectedCategory;
                                  model!=null?
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SubCategory(category: model,))):ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select category to add subcategory')));
                                },
                                child: const Text('No sub category found add here.')),): DropdownSearch<SubCategoryModel>(
                              // Initial Value
                              selectedItem: snapshot.selectedCategory,
                              dropdownSearchDecoration: InputDecoration(
                                  labelText: "Sub Category",
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              // Down Arrow Icon

                              itemAsString: (SubCategoryModel? m)=>m!.name,
                              // Array list of items
                              items: snapshot.subcategoryList,
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (SubCategoryModel? newValue) {
                                snapshot.setDropDownValue(newValue!);
                              },
                            );
                          }),
                    ),
                    IconButton(onPressed: (){
                      CategoriesModel? model= Provider.of<CategoriesProvider>(context, listen: false).selectedCategory;
                      if(model!=null){
                        showSubCategoryAdd(context,model );
                      }

                    }, icon:const Icon(Icons.add))
                  ],
                ),
              ),
             
            ],
          ),
        ),
      ],
    );
  }
}
