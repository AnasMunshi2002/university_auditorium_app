import 'package:flutter_test/flutter_test.dart';
import 'package:university_auditorium_app/algorithm/seating_algo.dart';
import 'package:university_auditorium_app/model/attendee_model.dart';
import 'package:university_auditorium_app/model/seat_model.dart';

void main() {
  test('Group of 4 gets contiguous seats', () {
    List<List<Seat>> seatingPlan = List.generate(12, (row) {
      return List.generate(18, (seatNum) {
        return Seat(
          id: '${row + 1}-${seatNum + 1}',
          row: row + 1,
          number: seatNum + 1,
        );
      });
    });
    final algorithm = SeatingAlgorithm(seatingPlan);
    algoCheck(algorithm, seatingPlan);
    constraintCheck(algorithm, seatingPlan);
  });
}

void algoCheck(SeatingAlgorithm algorithm, List<List<Seat>> seatingPlan) {
  final seats = algorithm.assignSeats(Attendee(groupSize: 4, id: ''));
  expect(seats.length, 4);
  expect(seats[3].number - seats[0].number, 3);
}

void constraintCheck(SeatingAlgorithm algorithm, List<List<Seat>> seatingPlan) {
  final seats =
      algorithm.assignSeats(Attendee(type: AttendeeType.child, id: ''));
  expect(seats.first.row, lessThan(seatingPlan.length - 2));
}
