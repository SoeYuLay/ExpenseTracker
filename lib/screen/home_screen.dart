import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:expense_tracker/screen/chart_screen.dart';
import 'package:expense_tracker/screen/expense_screen.dart';
import 'package:expense_tracker/screen/manage_cate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
      ExpenseScreen(),
      ChartScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context,listen: false).getUserData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Expenses'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text('${Provider.of<ExpenseProvider>(context,listen: true).getTodayExpenses()} MMK',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey
            ),),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.account_circle,size: 64,),
              ),
                accountName: Text(userData['name'] ?? 'John Doe'),
                accountEmail: Text(userData['email'] ?? 'johndoe@gmail.com')
            ),
            Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Manage Category'),
                      trailing: Icon(Icons.category),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ManageCateScreen())
                        );
                      },
                    )
                  ],
                )
            ),
            ListTile(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('Sign Out Alert!',textAlign: TextAlign.center),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Are you sure to Sign Out?'),
                            OverflowBar(
                              children: [
                                TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('No')),
                                TextButton(
                                    onPressed: ()async{
                                      await Provider.of<AuthProvider>(context,listen: false).signOut();
                                      Navigator.of(context).pop();
                                    }, child: Text('Yes')),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                );
              } ,
              title: Text('Sign Out'),
              trailing: Icon(Icons.logout),
            )
          ],
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
          selectedItemColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin),label: 'My Expense'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart),label: 'Chart'),
          ]
      ),
    );
  }
}
