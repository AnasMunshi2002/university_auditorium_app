import '../model/attendee_model.dart';
import '../model/seat_model.dart';

class SeatingAlgorithm {
  final List<List<Seat>> seatingPlan;
  final bool adminOverride;

  SeatingAlgorithm(this.seatingPlan, {this.adminOverride = false});

  List<Seat> assignSeats(Attendee attendee) {
    if (adminOverride) return _findAnySeats(attendee.groupSize);

    return switch (attendee.type) {
      AttendeeType.senior => _assignSenior(attendee),
      AttendeeType.wheelchair => _assignAccessible(attendee),
      _ =>
        attendee.groupSize > 1 ? _assignGroup(attendee) : _assignSolo(attendee),
    };
  }

  List<Seat> _assignGroup(Attendee group) {
    var bestBlock = _findContiguousBlock(group.groupSize);
    if (bestBlock.isNotEmpty) return bestBlock;
    if (group.groupSize > 2) {
      final halfSize = (group.groupSize / 2).ceil();
      final firstHalf =
          _assignGroup(Attendee(id: group.id, groupSize: halfSize));
      final secondHalf = _assignGroup(
          Attendee(id: group.id, groupSize: group.groupSize - halfSize));

      if (firstHalf.isNotEmpty && secondHalf.isNotEmpty) {
        return [...firstHalf, ...secondHalf];
      }
    }
    return _findAnySeats(group.groupSize);
  }

  List<Seat> _findContiguousBlock(int size) {
    for (final row in seatingPlan) {
      for (int i = 0; i <= row.length - size; i++) {
        final block = row.sublist(i, i + size);
        if (_isValidBlock(block)) {
          return block;
        }
      }
    }
    return [];
  }

  bool _isValidBlock(List<Seat> seats) {
    return seats.every((seat) =>
        !seat.isOccupied &&
        !seat.isReserved &&
        seat.type != SeatType.broken &&
        (seat.type != SeatType.ageRestricted ||
            seat.type != AttendeeType.child));
  }

  List<Seat> _assignSolo(Attendee attendee) {
    final candidates = seatingPlan
        .expand((row) => row)
        .where((seat) =>
            !seat.isOccupied &&
            !seat.isReserved &&
            seat.type != SeatType.broken &&
            (seat.type != SeatType.ageRestricted ||
                attendee.type != AttendeeType.child))
        .toList();

    candidates.sort((a, b) =>
        _calculateIsolationScore(b).compareTo(_calculateIsolationScore(a)));

    return candidates.isNotEmpty ? [candidates.first] : [];
  }

  double _calculateIsolationScore(Seat seat) {
    double score = 0.0;

    if (seat.number == 1 || seat.number == seatingPlan.first.length) {
      score += 10;
    }

    for (int r = seat.row - 2; r <= seat.row; r++) {
      if (r < 0 || r >= seatingPlan.length) continue;

      for (int n = seat.number - 2; n <= seat.number; n++) {
        if (n < 0 || n >= seatingPlan[r].length) continue;
        if (seatingPlan[r][n].isOccupied) score -= 5;
      }
    }

    return score;
  }

  List<Seat> _assignAccessible(Attendee attendee) {
    return seatingPlan
        .expand((row) => row)
        .where((seat) => seat.type == SeatType.accessible && !seat.isOccupied)
        .toList();
  }

  List<Seat> _assignSenior(Attendee senior) {
    return seatingPlan
        .expand((row) => row)
        .where((seat) => !seat.isOccupied && seat.type != SeatType.broken)
        .toList();
  }

  List<Seat> _findAnySeats(int count) {
    final available = seatingPlan
        .expand((row) => row)
        .where((seat) => !seat.isOccupied && seat.type != SeatType.broken)
        .take(count)
        .toList();
    return available.length == count ? available : [];
  }
}
