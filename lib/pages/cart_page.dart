import 'package:flutter/material.dart';
import 'package:flutter2/models/items.dart';

class MyCartPage extends StatefulWidget {
  final List<Item> cartItems;
  const MyCartPage({super.key, required this.cartItems});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {

  void reload(){
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontSize: 24, fontFamily: 'posh'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const Center(
              child: Text(
            "Items",
            style: TextStyle(fontSize: 22, fontFamily: 'cursive'),
          )),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.4,
            endIndent: MediaQuery.of(context).size.width * 0.4,
            thickness: 2,
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          for (var item in widget.cartItems)
            ItemsDisplay(item: item, cartItems: widget.cartItems, reloadCartPage: reload),
          const SizedBox(
            height: 6,
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
            color: Colors.black,
          ),
          const SizedBox(
            height: 15,
          ),
          if (widget.cartItems.isEmpty)
            const Center(
                child: Text(
              'No items in the cart',
              style: TextStyle(fontSize: 20, fontFamily: 'cursive'),
            )),
        ],
      ),
      bottomNavigationBar: OrderDetailsBar(cartItems: widget.cartItems, reloadCartPage: reload),
    );
  }
}

class ItemsDisplay extends StatefulWidget {
  final Item item;
  final List<Item> cartItems;
  final Function reloadCartPage;
  const ItemsDisplay({super.key, required this.item, required this.cartItems, required this.reloadCartPage});

  @override
  State<ItemsDisplay> createState() => _ItemsDisplayState();
}

class _ItemsDisplayState extends State<ItemsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.item.name,
          style: const TextStyle(fontFamily: 'cursive', fontSize: 17),
        ),
        subtitle: Text(
          'Price: \$${widget.item.price}',
          style: const TextStyle(
              fontFamily: 'cursive', fontSize: 15, color: Colors.deepPurple),
        ),
        leading: Image.network(
          widget.item.imageUrl,
          width: 60,
        ),
        trailing: IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Remove Item'),
                      content: const Text(
                          'Are you sure you want to remove this item from the cart?'),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.cartItems.remove(widget.item);
                            });
                            widget.reloadCartPage();
                            Navigator.of(context).pop();
                          },
                          child:
                              const Text('Yes', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}

class OrderDetailsBar extends StatefulWidget {
  final List<Item> cartItems;
  final Function reloadCartPage;
  const OrderDetailsBar({super.key, required this.cartItems, required this.reloadCartPage});

  @override
  State<OrderDetailsBar> createState() => OrderDetailsBarState();
}

class OrderDetailsBarState extends State<OrderDetailsBar> {
  int cartItemsPrice = 0;

  @override
  Widget build(BuildContext context) {
    cartItemsPrice = 0;
        for (var item in widget.cartItems) {
      cartItemsPrice += item.price;
    }
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Price: \$$cartItemsPrice',
              style: const TextStyle(fontSize: 20, fontFamily: 'cursive'),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Order Placed'),
                      content: const Text(
                          'Your order has been placed successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  });
              setState(() {
                widget.cartItems.clear();
                cartItemsPrice = 0;
              });
              widget.reloadCartPage();
            },
            child: const Text(
              'Place Order',
              style: TextStyle(fontSize: 18, fontFamily: 'cursive'),
            ),
          ),
        ],
      );
  }
}
