import 'dart:async';
import 'dart:convert';

import 'package:briskitnv/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection("kitchen").get().then((value){
    //   print(value.docs.length);
    //   if(value.docs.isNotEmpty) {
    //     for (var element in value.docs) {
    //       print(element.data());
    //       print(element.reference.path);
    //       // element.reference.delete();
    //     }
    //   } else{
    //     print("empty kitchen");
    //   }
    // });
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.computer),
                  child: Text(
                    "Point Of Order",
                    maxLines: 1,
                    style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.store),
                  child: Text(
                    "Kitchen Orders",
                    maxLines: 1,
                    style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: const Icon(Icons.list),
                  child: Text(
                    "Complete Orders",
                    maxLines: 1,
                    style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            title: const Text('Brisket NV'),
          ),
          body: TabBarView(
            children: [
              PointOfOrder(),
              KitchenOrders(),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class PointOfOrder extends StatelessWidget {
  PointOfOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        placeOrder(menuItems[index]);
                      },
                      title: Text(
                        menuItems[index]["name"].toString(),
                        style: themeData!.textTheme.headline6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        menuItems[index]["description"].toString(),
                        style: themeData!.textTheme.bodyText1,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(8),
              ),
            ))
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Platform.isAndroid
          ? Colors.white
          : Platform.isIOS
              ? Colors.white
              : Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        // color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                menuItems[index]["name"],
                                style: themeData!.textTheme.headline6,
                                maxLines: 1,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: menuItems[index]["items"].length,
                                    itemBuilder: (context, index2) {
                                      return ItemAddOrRemove(item: menuItems[index]["items"][index2]);
                                    },
                                  ),
                                ),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (box.read("lastOrderId") != null) {
                                          int lastOrder = box.read("lastOrderId");
                                          int newOrderId = lastOrder + 1;
                                          print(newOrderId);
                                          print("ordering now");
                                          box.write("lastOrderId", newOrderId);
                                          menuItems[index]["id"] = newOrderId.toString();
                                          FirebaseFirestore.instance.collection("kitchen").add(menuItems[index]);
                                        } else {
                                          box.write("lastOrderId", 1);
                                        }
                                        Get.back();
                                      },
                                      child: const Text("Place Order")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )),
            ],
          ))
        ],
      ),
    );
  }

  bool isCustomerNameSet = false;
  void placeOrder(Map<String, dynamic>? item) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: item!["name"],
        titleStyle: themeData!.textTheme.headline6,
        content: SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight * 0.50,
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: item["items"].length,
                  itemBuilder: (context, index) {
                    return ItemAddOrRemove(item: item["items"][index]);
                  },
                )),
              ],
            ),
          ),
        ),
        confirm: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    Get.back();

                    addCustomerName(item);
                  },
                  child: const Text("Name")),
              ElevatedButton(
                  onPressed: () {
                    if (!isCustomerNameSet) {
                      Get.back();
                      addCustomerName(item);
                      return;
                    }
                    if (box.read("lastOrderId") != null) {
                      int lastOrder = box.read("lastOrderId");
                      int newOrderId = lastOrder + 1;
                      print(newOrderId);
                      box.write("lastOrderId", newOrderId);
                      print(item);
                      item["id"] = newOrderId.toString();
                      isCustomerNameSet = false;
                      FirebaseFirestore.instance.collection("kitchen").add(item);
                      customerController.clear();
                    } else {
                      box.write("lastOrderId", 1);
                      isCustomerNameSet = false;
                      item["id"] = 1.toString();
                      FirebaseFirestore.instance.collection("kitchen").add(item);
                      customerController.clear();
                    }
                    Get.back();
                  },
                  child: const Text("Place Order")),
            ],
          ),
        ));
  }

  TextEditingController customerController = TextEditingController();
  FocusNode customerFocusNode = FocusNode();

  void addCustomerName(Map<String, dynamic> item) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Add Customer Name",
        titleStyle: themeData!.textTheme.headline6,
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: customerController,
                focusNode: customerFocusNode,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What is customer name?',
                  labelText: 'Name *',
                ),
                onChanged: (value) {
                  isCustomerNameSet = true;
                },
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String? value) {
                  return value!.contains('@') ? 'Do not use the @ char.' : null;
                },
              )
            ],
          ),
        ),
        confirm: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (customerFocusNode.hasFocus) {
                      customerFocusNode.unfocus();
                      return;
                    }
                    Get.back();
                    placeOrder(item);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (customerFocusNode.hasFocus) {
                      customerFocusNode.unfocus();
                      return;
                    }
                    Get.back();
                    customerFocusNode.unfocus();
                    item["customer"] = "";
                    placeOrder(item);
                  },
                  child: const Text("Name")),
            ],
          ),
        ));
  }
}

class KitchenOrders extends StatefulWidget {
  const KitchenOrders({Key? key}) : super(key: key);

  @override
  State<KitchenOrders> createState() => _KitchenOrdersState();
}

class _KitchenOrdersState extends State<KitchenOrders> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Platform.isAndroid
          ? Colors.white
          : Platform.isIOS
              ? Colors.white
              : Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                      // <2> Pass `Stream<QuerySnapshot>` to stream
                      stream: FirebaseFirestore.instance.collection('kitchen').orderBy("id").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                          final List<DocumentSnapshot> documents = snapshot.data!.docs;
                          return GridView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                onDismissed: (direction) {
                                  setState(() {
                                    box.write(documents[index]["id"], null);
                                    documents[index].reference.delete();
                                  });
                                },
                                key: UniqueKey(),
                                child: Card(
                                  // color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 55.h,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                          child: Text(
                                                        "Order#: ",
                                                        style: themeData!.textTheme.headline6,
                                                        maxLines: 1,
                                                      )),
                                                      Flexible(
                                                          child: Text(
                                                        documents[index]["id"].toString(),
                                                        style: themeData!.textTheme.headline6,
                                                        maxLines: 1,
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                    child: OrderItemTimer(
                                                  orderId: documents[index]["id"],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            documents[index]["name"],
                                            style: themeData!.textTheme.headline6,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: documents[index]["items"].length,
                                          itemBuilder: (context, index2) {
                                            return ItemAddOrRemove(item: documents[index]["items"][index2]);
                                          },
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("");
                        }
                        return Container();
                      }),
                ),
              )),
            ],
          ))
        ],
      ),
    );
  }
}

class OrderItemTimer extends StatefulWidget {
  String? orderId;
  OrderItemTimer({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderItemTimerState createState() => _OrderItemTimerState();
}

class _OrderItemTimerState extends State<OrderItemTimer> {
  Duration duration = const Duration();
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSecond = 1;
    if (box.read(widget.orderId.toString()) != null && duration.inSeconds == 0) {
      setState(() {
        var starrt = box.read(widget.orderId.toString());
        final seconds = duration.inSeconds + starrt;
        duration = Duration(seconds: seconds.toInt());
        box.write(widget.orderId.toString(), duration.inSeconds);
      });
    }
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      duration = Duration(seconds: seconds);
      box.write(widget.orderId.toString(), duration.inSeconds);
      // print(duration.inSeconds);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildTime(),
    );
  }

  Widget buildTime() {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));
    return Column(
      children: [
        Row(
          children: [
            buildTimeCard(time: minutes, header: "MINUTES"),
            SizedBox(
              width: 3.w,
              child: Center(
                  child: Text(":",
                      textAlign: TextAlign.center,
                      style: themeData!.textTheme.headline4!.copyWith(color: Colors.black))),
            ),
            buildTimeCard(time: seconds, header: "SECONDS"),
          ],
        )
      ],
    );
  }
}

Widget buildTimeCard({required String? time, required String? header}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
        child: Text(
          time.toString(),
          maxLines: 1,
          style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
        ),
      ),
      // Text(header.toString()),
    ],
  );
}

class ItemAddOrRemove extends StatefulWidget {
  Map<String, dynamic>? item;
  ItemAddOrRemove({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemAddOrRemove> createState() => _ItemAddOrRemoveState();
}

class _ItemAddOrRemoveState extends State<ItemAddOrRemove> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        setState(() {
          widget.item!["add"] = !widget.item!["add"];
        });
      },
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              widget.item!["item"],
              maxLines: 1,
              style: TextStyle(
                decoration: widget.item!["add"] ? TextDecoration.none : TextDecoration.lineThrough,
                decorationColor: Colors.red,
              ),
            )),
            // Text(widget.item!["add"].toString(),),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> menuSides = [
  {
    "item": "Hashbrowns",
    "add": true,
  },
  {
    "item": "Loaded Hashbrowns - green peppers",
    "add": true,
  },
  {
    "item": "Onions & Cheese",
    "add": true,
  },
  {
    "item": "Grits",
    "add": true,
  },
  {
    "item": "Macaroni & Cheese",
    "add": true,
  },
  {
    "item": "Collard Greens",
    "add": true,
  },
  {
    "item": "Tomatos souces",
    "add": true,
  }
];

List<Map<String, dynamic>> menuItems = [
  {
    "id": "1",
    "customer": "",
    "name": "The Rooster",
    "description": "Mile High Briskit with our special recipe Quintin's Fried Checken breast, with honey, *fried egg,"
        " cheddar cheese and jalepeno pepper jelly",
    "items": menuSides,
  },
  {
    "id": "2",
    "customer": "",
    "name": "The Loaded Rooster Brisket",
    "description": "Mile Hgh Biskit with our special recial recipe Quintin's Fried Chicken breast, sauteed spinach, "
        "*over-easy egg, goat cheese, and topped with tomato gravy",
    "items": menuSides,
  },
  {
    "id": "3",
    "customer": "",
    "name": "Mr. V's",
    "description": "Mile High Biskit served with our special recipe Quintin's Fried Chicken breast, crispy bacon, "
        "*fried egg, cheddar cheese and signature sausage gravy.",
    "items": menuSides,
  },
  {
    "id": "4",
    "customer": "",
    "name": "Pork Savage",
    "description": "Mile High Biskit with juicy sausage, crispy bacon, *fried egg, cheddar cheese, and topped with our"
        " signature sausage gravy.",
    "items": menuSides,
  },
  {
    "id": "5",
    "customer": "",
    "name": "Bacon, Egg, & Cheddar Cheese",
    "description": "Mile High Biskit with served crispy bacon, *fried egg, your choice of pimento or cheddar cheese",
    "items": menuSides,
  },
  {
    "id": "6",
    "customer": "",
    "name": "Not Your Mama's Biskit & Gravy",
    "description": "Mile High Biskit served with your choice of homemade gravy.",
    "items": menuSides,
  },
  {
    "id": "7",
    "customer": "",
    "name": "BLT",
    "description": "Mile high Biskit served with crispy bacon, roasted tomato, sauteed spinach, and lemon basil mayo.",
    "items": menuSides,
  },
];
