import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../algorithm/seating_algo.dart';
import '../controller/seat_manager.dart';
import '../model/attendee_model.dart';
import '../model/seat_model.dart';
import 'components/seat.dart';

class SeatArrangement extends StatelessWidget {
  const SeatArrangement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Auditorium'),
        actions: [
          _buildAdminToggle(context),
          //_buildInitializeButton(context),
        ],
      ),
      body: Column(
        children: [
          _buildStageIndicator(),
          _buildLegend(),
          Expanded(child: _buildSeatingPlan(context)),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildAdminToggle(BuildContext context) {
    final seatManager = context.watch<SeatManager>();
    return IconButton(
      icon: Icon(
        seatManager.adminMode ? Icons.admin_panel_settings : Icons.lock_outline,
        color: seatManager.adminMode ? Colors.red : Colors.white,
      ),
      onPressed: seatManager.toggleAdminMode,
    );
  }

  Widget _buildStageIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'STAGE AREA',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        children: [
          const _LegendItem(color: Colors.grey, label: 'Available'),
          const _LegendItem(color: Colors.blue, label: 'Selected'),
          const _LegendItem(color: Colors.red, label: 'VIP'),
          const _LegendItem(color: Colors.green, label: 'Accessible'),
          const _LegendItem(color: Colors.orange, label: 'Age Restricted'),
          const _LegendItem(color: Colors.black, label: 'Occupied'),
          _LegendItem(color: Colors.grey[800]!, label: 'Broken'),
        ],
      ),
    );
  }

  Widget _buildSeatingPlan(BuildContext context) {
    final seatManager = context.watch<SeatManager>();

    if (seatManager.seatingPlan.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: () => seatManager.initializeAuditorium(
            rows: 12,
            seatsPerRow: 18,
          ),
          child: const Text('Initialize Auditorium Layout'),
        ),
      );
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                ...seatManager.seatingPlan.map((row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: row.map((seat) {
                      return SeatWidget(
                        seat: seat,
                        isAdminMode: seatManager.adminMode,
                        onTap: () => _handleSeatTap(context, seat),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSeatTap(BuildContext context, Seat seat) {
    final seatManager = context.read<SeatManager>();

    if (seatManager.adminMode) {
      // Admin can toggle any seat
      seat.isOccupied = !seat.isOccupied;
      seatManager.notifyListeners();
    } else if (!seat.isOccupied && seat.type != SeatType.broken) {
      // Regular user selection
      seat.isReserved = !seat.isReserved;
      seatManager.notifyListeners();
    }
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _simulateGroupBooking(context),
            child: const Text('Simulate Group Booking'),
          ),
          ElevatedButton(
            onPressed: () => _simulateCancellation(context),
            child: const Text('Simulate Cancel'),
          ),
        ],
      ),
    );
  }

  void _simulateGroupBooking(BuildContext context) {
    final seatManager = context.read<SeatManager>();
    final algorithm = SeatingAlgorithm(seatManager.seatingPlan);

    final group = Attendee(id: 'group1', groupSize: 4);
    final seats = algorithm.assignSeats(group);

    if (seats.isNotEmpty) {
      for (final seat in seats) {
        seat.isReserved = true;
        seat.reservationId = group.id;
      }
      seatManager.notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned ${seats.length} seats to group')),
      );
    }
  }

  void _simulateCancellation(BuildContext context) {
    final seatManager = context.read<SeatManager>();
    final occupiedSeats = seatManager.seatingPlan
        .expand((row) => row)
        .where((seat) => seat.isReserved)
        .take(3)
        .toList();

    if (occupiedSeats.isNotEmpty) {
      seatManager.processCancellation(occupiedSeats);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cancelled 3 reservations')),
      );
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
