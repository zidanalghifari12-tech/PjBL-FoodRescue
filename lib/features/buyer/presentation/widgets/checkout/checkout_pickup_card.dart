import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class CheckoutPickupCard extends StatelessWidget {
  final String selectedSchedule;
  final String selectedTime;
  final ValueChanged<String> onScheduleChanged;
  final ValueChanged<String> onTimeChanged;
  final String pickupAddress;
  final TextEditingController notesController;

  const CheckoutPickupCard({
    super.key,
    required this.selectedSchedule,
    required this.selectedTime,
    required this.onScheduleChanged,
    required this.onTimeChanged,
    required this.pickupAddress,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleOptions = ['Hari ini', 'Besok'];
    final timeOptions = ['08:00 WIB', '10:00 WIB', '14:00 WIB', '16:00 WIB'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Informasi pengambilan',
            style: TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.neutralColor,
            ),
          ),
          const SizedBox(height: 12),

          // Waktu Pengambilan Highlight Box (like screenshot)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCFCE7)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waktu pengambilan',
                        style: TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$selectedSchedule, $selectedTime',
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutralColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Schedule Selection (Chips)
          const Text(
            'Pilih Jadwal Pengambilan',
            style: TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: scheduleOptions.map((schedule) {
              final isSelected = selectedSchedule == schedule;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(schedule),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) onScheduleChanged(schedule);
                  },
                  selectedColor: const Color(0xFFDCFCE7),
                  backgroundColor: const Color(0xFFF8FAFC),
                  labelStyle: TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF047857)
                        : const Color(0xFF475569),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Time Slots Selection (Chips)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeOptions.map((time) {
              final isSelected = selectedTime == time;
              return ChoiceChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (val) {
                  if (val) onTimeChanged(time);
                },
                selectedColor: const Color(0xFFDCFCE7),
                backgroundColor: const Color(0xFFF8FAFC),
                labelStyle: TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF047857)
                      : const Color(0xFF475569),
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Lokasi Pengambilan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Toko',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutralColor,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        pickupAddress,
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Catatan untuk Penjual TextField
          const Text(
            'Catatan untuk Penjual',
            style: TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: notesController,
            maxLines: 2,
            style: const TextStyle(
              fontFamily: AppTheme.bodyFontFamily,
              fontSize: 12.5,
              color: AppTheme.neutralColor,
            ),
            decoration: InputDecoration(
              hintText:
                  'Tambahkan catatan (opsional, misal: bawa karung sendiri, tiba pk 10)',
              hintStyle: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 11.5,
                color: Color(0xFF94A3B8),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Notice Info Row (from screenshot)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Color(0xFF64748B),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Bawa wadah sendiri dan tunjukkan nomor pesanan saat tiba.',
                  style: TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

