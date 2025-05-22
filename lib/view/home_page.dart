import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_auditorium_app/controller/seat_manager.dart';

import 'seat_arrangement.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? category;
  final _vipController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final seatManager = context.watch<SeatManager>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("UWL Auditorium"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatArrangement(
                              isAccessible: category == "Accessible",
                              isAgeRestricted: category == "child",
                              isVIP: category == "VIP"),
                        ));
                    seatManager.toggleAdminMode;
                  },
                  child: const Text("Login as Admin")),
              const PopupMenuItem(child: Text("Exit app"))
            ],
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "No of Visitors",
              style: TextStyle(fontSize: 16),
            ),
            Consumer<SeatManager>(
              builder: (context, value, child) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filledTonal(
                            onPressed: () {
                              if (value.groupSize != 1) {
                                value.decrementGroupSize();
                              }
                            },
                            icon: const Icon(Icons.remove)),
                        Text(
                          value.groupSize.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton.filledTonal(
                          onPressed: () {
                            value.incrementGroupSize();
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownMenu(
                hintText: "Select category",
                onSelected: (value) {
                  setState(() {
                    category = value;
                  });
                },
                width: double.maxFinite,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: "VIP", label: "VIP"),
                  DropdownMenuEntry(value: "Regular", label: "Regular"),
                  DropdownMenuEntry(value: "Accessible", label: "Accessible"),
                  DropdownMenuEntry(value: "child", label: "under 16"),
                ]),
            const SizedBox(
              height: 16,
            ),
            Visibility(
              visible: category == "VIP",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("VIP coupon"),
                  TextField(
                    controller: _vipController,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                  onPressed: () {
                    if (category == "VIP" && _vipController.text.isEmpty) {
                      SnackBar snackBar = const SnackBar(
                          content: Text("Please enter VIP Coupon!!"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatArrangement(
                                isAccessible: category == "Accessible",
                                isAgeRestricted: category == "child",
                                isVIP: category == "VIP"),
                          ));
                    }
                  },
                  child: const Text("Book Now")),
            ),
          ],
        ),
      ),
    );
  }
}
