import 'package:expense_tracker/model/category.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ManageCateScreen extends StatefulWidget {
  const ManageCateScreen({super.key});

  @override
  State<ManageCateScreen> createState() => _ManageCateScreenState();
}

class _ManageCateScreenState extends State<ManageCateScreen> {
  final nameController = TextEditingController();
  void showActionDialog({bool isUpdate =false, int? index, Category? category}) {
    if(isUpdate == true){
      nameController.text = category!.cateName;
    }

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isUpdate ? 'Update Category' : 'Add New Category',
                  style: TextStyle(
                    fontSize: 20
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Name')
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                      onPressed: (){
                        if(nameController.text.isNotEmpty){
                          if(isUpdate){
                            category!.cateName=nameController.text.trim();
                            Provider.of<CategoryProvider>(context,listen: false).updateItem(index!, category);
                          }else{
                            Uuid uuid = Uuid();
                            Provider.of<CategoryProvider>(context,listen: false).addItem(
                                Category(cateID: uuid.v4(), cateName: nameController.text.trim())
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isUpdate ? 'Category Updated':'New Category added'))
                          );
                          nameController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Save'))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Category'),
        actions: [IconButton(onPressed: () => showActionDialog(), icon: Icon(Icons.add))],
      ),
      body: FutureBuilder(
          future:
              Provider.of<CategoryProvider>(context, listen: false).initBox(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                List<Category> categories = provider.categories;
                return categories.isEmpty
                    ? Center(child: Text('No Category'))
                    : ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onLongPress: ()=>showActionDialog(isUpdate: true,index: index,category: categories[index]),
                            title: Text(categories[index].cateName),
                            trailing: IconButton(
                                onPressed: () {
                                  Provider.of<CategoryProvider>(context,listen: false).deleteItem(index);
                                }, icon: Icon(Icons.delete,color: Colors.deepOrange,)),
                          );
                        },
                      );
              });
            }
          }),
    );
  }
}
