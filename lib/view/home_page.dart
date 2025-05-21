import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_auditorium_app/controller/seat_manager.dart';

import 'seat_arrangement.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UWL Auditorium"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [],
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text("Name"),
                Badge(
                  child: Text("*"),
                )
              ],
            ),
            const TextField(),
            const SizedBox(
              height: 10,
            ),
            const Text("No of Visitors"),
            Consumer<SeatManager>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          value.groupSize = value.groupSize == 0
                              ? 0
                              : value.groupSize ?? 1 - 1;
                        },
                        icon: const Icon(Icons.remove)),
                    Text(value.groupSize.toString()),
                    IconButton(
                      onPressed: () {
                        value.groupSize = value.groupSize ?? 0 + 1;
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                );
              },
            ),
            const DropdownMenu(dropdownMenuEntries: [
              DropdownMenuEntry(value: "VIP", label: "VIP"),
              DropdownMenuEntry(value: "Accessible", label: "Accessible"),
              DropdownMenuEntry(value: "VIP", label: "VIP"),
            ]),
            const Text("VIP coupon"),
            const TextField()
          ],
        ),
      ),
      floatingActionButton: Expanded(
        child: FilledButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeatArrangement(),
                  ));
            },
            child: const Row(
              children: [
                Text("Book"),
              ],
            )),
      ),
    );
  }
}
