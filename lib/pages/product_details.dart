import 'package:flutter/material.dart';
import 'package:flutter2/models/items.dart';

class ProductDetails extends StatefulWidget {
  final Item item;
  final List<Item> cartItems;
  const ProductDetails({super.key, required this.item, required this.cartItems});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: widget.item.id,
              child: Image.network(
                widget.item.imageUrl,
                height: MediaQuery.of(context).size.height * 0.5,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(height: 20),
            Center(
                child: Text(widget.item.description,
                    style:
                        TextStyle(fontSize: 18, color: Colors.grey.shade600))),
            const SizedBox(height: 20),
            Center(
                child: Text('Price: \$${widget.item.price}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700))),
            const Divider(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Cancelcontainer(),
          CartContainer(cartItems: widget.cartItems, currItem: widget.item),
        ],
      ),
    );
  }
}

class CartContainer extends StatefulWidget {
  final List<Item> cartItems;
  final Item currItem;
  const CartContainer({super.key, required this.cartItems, required this.currItem});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  bool addedToCart = false;

  @override
  void initState() {
    super.initState();
    addedToCart = widget.cartItems.contains(widget.currItem);
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          if(addedToCart){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item already in cart')));
          } else {
            setState(() {
              addedToCart = true;
              widget.cartItems.add(widget.currItem);
            });
          }
        },
        splashColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: MediaQuery.of(context).size.width * 0.4,
          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
            color: addedToCart ? Colors.greenAccent.shade400 : Colors.amber.shade700,
          ),
          child: addedToCart ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Added to', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 10),
                Icon(Icons.shopping_cart, color: Colors.white),
              ],
            ),
          ) : const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add to', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 10),
                Icon(Icons.shopping_cart, color: Colors.white),
              ],
            ),
          ),
        ),
    );
  }
}

class Cancelcontainer extends StatelessWidget {
  const Cancelcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      splashColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.05),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Colors.red,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}