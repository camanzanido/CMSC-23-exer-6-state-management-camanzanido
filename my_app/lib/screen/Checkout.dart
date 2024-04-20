import 'package:flutter/material.dart';
import '../model/Item.dart';
import "package:provider/provider.dart";
import '../provider/shoppingcart_provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});
  @override
  State<Checkout> createState() => CheckoutPage();

}

class CheckoutPage extends State<Checkout>{
  @override
  Widget build(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    double totalPrice = 0; //to get the total price for payment
    for (var product in products) {
      totalPrice += product.price;
    }
    return Scaffold(
      appBar: AppBar( //customized the app bar
        title: const Text("Checkout",style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange.shade400,
        iconTheme: IconThemeData(color: Colors.white),
       ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: Text("Item Details"),
          ),          
          const Divider(height: 4, color: Colors.black),

          getItems(context),

          if(products.isNotEmpty) //display the total price and the payment button if the shopping cart isnt empty
          Column(
            children: [
              const Divider(height: 4, color: Colors.black),
              Center(
                child:Text("Total Price: P$totalPrice")
              ),

              ]
          ),
          Flexible(
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                    if(products.isNotEmpty) //to create a button for paying if cart has item
                    ElevatedButton(
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();
                          ScaffoldMessenger.of(context)    //to prompt the "payment successful"
                              .showSnackBar(const SnackBar(
                            content: Text("Payment Successful!"),
                            duration: Duration(seconds: 1, milliseconds: 100),
                          ));
                        },
                        child: const Text("PayNow",style:TextStyle(color: Colors.white)),
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
                    trailing: Text("${products[index].price}", style: TextStyle(fontSize: 15),),
                  );
                },
              )),
              ],
          ));
  }
}
