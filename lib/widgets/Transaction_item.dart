import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required Transaction sortedTransaction,
    @required Function deleteTx,
  }) : _sortedTransaction = sortedTransaction, _deleteTx = deleteTx, super(key: key);

  final Transaction _sortedTransaction;
  final Function _deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: FittedBox(
                    child: Text(
                        '\$${_sortedTransaction.amount.toStringAsFixed(2)}')),
              ),
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            _sortedTransaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(DateFormat.yMMMd()
              .format(_sortedTransaction.date)),
          trailing: MediaQuery.of(context).size.width <= 460
              ? IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    _deleteTx(_sortedTransaction.id);
                  })
              : FlatButton.icon(
                  onPressed: () {
                    _deleteTx(_sortedTransaction.id);
                  },
                  icon: Icon(Icons.delete),
                  textColor: Theme.of(context).errorColor,
                  label: Text('Delete')),
        ),
      ),
    );
  }
}