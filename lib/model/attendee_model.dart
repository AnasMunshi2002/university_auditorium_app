enum AttendeeType { regular, child, senior, wheelchair }

class Attendee {
  final String id;
  final AttendeeType type;
  final int groupSize;
  final List<String>? groupMembers;

  Attendee({
    required this.id,
    this.type = AttendeeType.regular,
    this.groupSize = 1,
    this.groupMembers,
  });
}
