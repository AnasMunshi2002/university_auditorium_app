import 'package:flutter/material.dart';

import '../../model/seat_model.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final VoidCallback onTap;
  final bool isAdminMode;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.onTap,
    this.isAdminMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getSeatColor(),
          border: Border.all(
            color: isAdminMode ? Colors.yellow : Colors.transparent,
            width: isAdminMode ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            seat.number.toString(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getSeatColor() {
    if (seat.isOccupied) return Colors.black;
    return switch (seat.type) {
      SeatType.vip => Colors.red[400]!,
      SeatType.accessible => Colors.green[400]!,
      SeatType.broken => Colors.grey[800]!,
      SeatType.ageRestricted => Colors.orange[300]!,
      _ => seat.isReserved ? Colors.blue[200]! : Colors.grey[200]!,
    };
  }

  Color _getTextColor() {
    return seat.isOccupied || seat.type == SeatType.broken
        ? Colors.white
        : Colors.black;
  }
}
