import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;


  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(order.dateTime)),
            trailing: IconButton(icon: Icons.expand_more, onPressed: () {},),
          )
        ],
      ),
    );
  }
}
