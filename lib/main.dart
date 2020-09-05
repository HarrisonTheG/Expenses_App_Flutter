import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:Expenses_App/widgets/New_transaction.dart';
import 'package:Expenses_App/widgets/Transaction_list.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './models/Transaction.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations(
  //[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime datePicked) {
    final newTx = Transaction(
      id: 't ${_userTransactions.length}',
      title: title,
      amount: amount,
      date: datePicked,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }
  Widget _buildAppBar(){
    return Platform.isIOS ? CupertinoNavigationBar(
       middle: Text('Personal Expenses'),
       trailing: GestureDetector(child: Icon(CupertinoIcons.add), onTap: () => _startNewTransaction(context),),
    ): AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              _startNewTransaction(context);
            })
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final pageBody = SafeArea (child: SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart'),
                    Switch.adaptive(
                        activeColor: Theme.of(context).accentColor,
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        })
                  ],
                ),
              if (!isLandscape)
                Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)),
              if (!isLandscape) txListWidget,
              if (isLandscape)
                _showChart
                    ? Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        child: Chart(_recentTransactions))
                    : txListWidget
            ]),
      ));

    return Platform.isIOS ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar,)
    : 
     Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButton: Platform.isIOS ? Container () : FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _startNewTransaction(context);
          }),
      floatingActionButtonLocation: !isLandscape
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }
}
