import 'dart:math';

import 'package:flutter/material.dart';

import '../model/seat_model.dart';

class SeatManager extends ChangeNotifier {
  List<List<Seat>> seatingPlan = [];
  bool adminMode = false;
  final List<Seat> _brokenSeats = [];
  final Random _random = Random();
  int groupSize = 1;

  void incrementGroupSize() {
    groupSize++;
    notifyListeners();
  }

  void decrementGroupSize() {
    groupSize--;
    notifyListeners();
  }

  void initializeAuditorium({required int rows, required int seatsPerRow}) {
    seatingPlan = List.generate(rows, (row) {
      return List.generate(seatsPerRow, (seatNum) {
        return Seat(
          id: '${row + 1}-${seatNum + 1}',
          row: row + 1,
          number: seatNum + 1,
        );
      });
    });

    _markSpecialSeats();
    _markBrokenSeats();
    _markAgeRestrictedZones();
    notifyListeners();
  }

  void _markSpecialSeats() {
    for (int row = 0; row < 3; row++) {
      final center = seatingPlan[row].length ~/ 2;
      for (int i = center - 1; i <= center + 1; i++) {
        seatingPlan[row][i].type = SeatType.vip;
      }
    }

    for (int row = 0; row < seatingPlan.length; row += 4) {
      seatingPlan[row][0].type = SeatType.accessible;
      seatingPlan[row].last.type = SeatType.accessible;
    }
  }

  void _markBrokenSeats() {
    for (int i = 0; i < 5; i++) {
      final row = _random.nextInt(seatingPlan.length);
      final seat = _random.nextInt(seatingPlan[row].length);
      seatingPlan[row][seat].type = SeatType.broken;
      _brokenSeats.add(seatingPlan[row][seat]);
    }
  }

  void _markAgeRestrictedZones() {
    for (int row = seatingPlan.length - 2; row < seatingPlan.length; row++) {
      for (var seat in seatingPlan[row]) {
        seat.type = SeatType.ageRestricted;
      }
    }
  }

  void toggleAdminMode() {
    adminMode = !adminMode;
    notifyListeners();
  }

  void processCancellation(List<Seat> seats) {
    for (var seat in seats) {
      seat.isOccupied = false;
      seat.isReserved = false;
    }
    notifyListeners();
  }
}
