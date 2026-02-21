

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PickupSlotBookingScreen extends StatefulWidget {
  const PickupSlotBookingScreen({super.key});

  @override
  State<PickupSlotBookingScreen> createState() => _PickupSlotBookingScreenState();
}

class _PickupSlotBookingScreenState extends State<PickupSlotBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedSlotId;
  final String vendorId = 'vendor_123';

  @override
  void initState() {
    super.initState();
    _checkAndGenerateSlots();
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate);

  Future<void> _checkAndGenerateSlots() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pickup_slots')
        .where('vendorId', isEqualTo: vendorId)
        .where('date', isEqualTo: formattedDate)
        .get();

    if (snapshot.docs.isEmpty) {
      await _generateSlotsForDate(formattedDate);
      setState(() {});
    }
  }

  Future<void> _generateSlotsForDate(String date) async {
    final collection = FirebaseFirestore.instance.collection('pickup_slots');
    for (int hour = 10; hour <= 18; hour++) {
      await collection.add({
        'vendorId': vendorId,
        'date': date,
        'startTime': '${hour.toString().padLeft(2, '0')}:00',
        'endTime': '${(hour + 1).toString().padLeft(2, '0')}:00',
        'isBooked': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          '⏰ Pickup Slot Booking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF1A0F0F) : Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                  : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Picker Section
          _buildDatePickerSection(isDarkMode),
          SizedBox(height: 16),

          // Selected Date Display
          _buildSelectedDateDisplay(isDarkMode),
          SizedBox(height: 16),

          // Slots List
          Expanded(child: _buildSlotList(isDarkMode)),
        ],
      ),
      bottomNavigationBar: selectedSlotId != null
          ? _buildBottomBookingSection(isDarkMode)
          : null,
    );
  }

  Widget _buildDatePickerSection(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
              : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Pickup Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.brown[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Choose your preferred date',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    selectedSlotId = null;
                  });
                  await _checkAndGenerateSlots();
                }
              },
              icon: Icon(Icons.calendar_today, size: 18),
              label: Text('Pick Date'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateDisplay(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.date_range, color: Color(0xFFD4AF37), size: 20),
          SizedBox(width: 8),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotList(bool isDarkMode) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pickup_slots')
          .where('vendorId', isEqualTo: vendorId)
          .where('date', isEqualTo: formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        final slots = snapshot.data!.docs;

        if (slots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 80, color: Color(0xFFD4AF37).withOpacity(0.5)),
                SizedBox(height: 16),
                Text(
                  'No slots available',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isBooked = slot['isBooked'] as bool;
            final isSelected = selectedSlotId == slot.id;
            final startTime = slot['startTime'] as String;
            final endTime = slot['endTime'] as String;

            return GestureDetector(
              onTap: isBooked ? null : () {
                setState(() {
                  selectedSlotId = slot.id;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isBooked
                        ? [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)]
                        : isSelected
                        ? [Color(0xFFD4AF37).withOpacity(0.3), Color(0xFFB8941F).withOpacity(0.2)]
                        : isDarkMode
                        ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
                        : [Colors.white, Color(0xFFF8F5F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: isBooked
                        ? Colors.red.withOpacity(0.3)
                        : isSelected
                        ? Color(0xFFD4AF37)
                        : Color(0xFFD4AF37).withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$startTime',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isBooked
                            ? Colors.red
                            : (isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                    Text(
                      'to $endTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: isBooked
                            ? Colors.red
                            : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red.withOpacity(0.1)
                            : Color(0xFFD4AF37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isBooked
                              ? Colors.red
                              : Color(0xFFD4AF37).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        isBooked ? 'BOOKED' : 'AVAILABLE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isBooked
                              ? Colors.red
                              : Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomBookingSection(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Slot',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '${selectedSlotId != null ? 'Time slot selected' : ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _confirmBooking,
              icon: Icon(Icons.confirmation_number, size: 20),
              label: Text(
                'Confirm Booking',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFD4AF37),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() async {
    if (selectedSlotId == null) return;

    await FirebaseFirestore.instance
        .collection('pickup_slots')
        .doc(selectedSlotId)
        .update({'isBooked': true});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pickup slot booked successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      selectedSlotId = null;
    });
  }
}

