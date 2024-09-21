import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adminpage/AD_main_page.dart';
import 'cashierpage/mainpage.dart';
import 'data/api/sqlite.dart';
import 'data/model/selectedCashiermodel.dart';
import 'data/model/selectedCusmodel.dart';
import 'loginwidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper().LoadBranch();
  await DatabaseHelper().LoadCustomer();
  await DatabaseHelper().LoadServiceType();
  await DatabaseHelper().LoadService();
  await DatabaseHelper().LoadEmployee();
  await DatabaseHelper().LoadOrder();
  await DatabaseHelper().LoadOrderService();
  await DatabaseHelper().LoadReceipt();
  await DatabaseHelper().LoadReceiptService();
  await DatabaseHelper().LoadBranchService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedCusModel()),
        ChangeNotifierProvider(create: (context) => SelectedCashierModel()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ADMainPage(),

      home: LoginWidget(),
    );
  }
}
