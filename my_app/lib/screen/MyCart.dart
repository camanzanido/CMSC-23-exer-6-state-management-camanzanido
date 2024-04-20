import 'package:flutter/material.dart';
import '../model/Item.dart';
import "package:provider/provider.dart";
import '../provider/shoppingcart_provider.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) { 
    List<Item> products = context.watch<ShoppingCart>().cart; //to get the updated contents of shopping cart
    double totalPrice = 0;    //to get the total price of the item/s
    for (var product in products) {
      totalPrice += product.price;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart",style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange.shade400,
        iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getItems(context),
          
          if(products.isNotEmpty) //to only show the total price if the cart is not empty
          Center(
            child: Text("Total: P$totalPrice")
          ),

          Flexible(
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                    ElevatedButton(
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();
                        },
                        child: const Text("Reset",style:TextStyle(color: Colors.white)),
                         style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade400, // Set the background color to orange
                          ),
                    ),
                        //button to go the checkout screen 
                    ElevatedButton(
                        onPressed: () {
                         Navigator.pushNamed(context, "/checkout");
                        },
                        child: const Text("Checkout",style:TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                        )
                    ),
                        
                ]))),
          TextButton(
            child: const Text("Go back to Product Catalog"),
            onPressed: () {
              Navigator.pushNamed(context, "/products");
            },
          ),
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    String productname = "";
    return products.isEmpty
        ? const Text('No Items yet!')
        : Expanded(
            child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.food_bank),
                    title: Text(products[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        productname = products[index].name;
                        context.read<ShoppingCart>().removeItem(productname);

                        if (products.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("$productname removed!"),
                            duration:
                                const Duration(seconds: 1, milliseconds: 100),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Cart Empty!"),
                            duration: Duration(seconds: 1, milliseconds: 100),
                          ));
                        }
                      },
                    ),
                  );
                },
              )),
              ],
          ));
  }

}



