import 'package:flutter/material.dart';
import './Transaction_item.dart';
import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTx;

  TransactionList(this._transactions, this._deleteTx);

  List<Transaction> get _sortedTransactions {
    List<Transaction> _unsortedTransactions = _transactions;
    if (_transactions.isEmpty) {
      return null;
    } else {
      _unsortedTransactions.sort((b, a) {
        return a.date.compareTo(b.date);
      });
      return _unsortedTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover)),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(sortedTransaction: _sortedTransactions[index], deleteTx: _deleteTx);
            },
            itemCount: _transactions.length,
          );
  }
}


