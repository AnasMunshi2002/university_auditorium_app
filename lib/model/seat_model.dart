enum SeatType { regular, vip, accessible, broken, ageRestricted }

class Seat {
  late final String id;
  final int row;
  final int number;
  SeatType type;
  bool isOccupied;
  bool isReserved;
  String? reservationId;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    this.type = SeatType.regular,
    this.isOccupied = false,
    this.isReserved = false,
  });
}
