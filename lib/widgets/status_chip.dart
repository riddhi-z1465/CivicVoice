import 'package:flutter/material.dart';

/// Clean, accessible badge showing the state of a civic issue report
class StatusChip extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'submitted':
        bg = const Color(0xFFEFF6FF); // Soft blue
        text = const Color(0xFF1D4ED8);
        border = const Color(0xFFBFDBFE);
        icon = Icons.outbox_rounded;
        break;
      case 'under review':
        bg = const Color(0xFFFFFBEB); // Soft amber
        text = const Color(0xFFB45309);
        border = const Color(0xFFFDE68A);
        icon = Icons.pending_actions_rounded;
        break;
      case 'in progress':
        bg = const Color(0xFFF5F3FF); // Soft purple
        text = const Color(0xFF6D28D9);
        border = const Color(0xFFDDD6FE);
        icon = Icons.engineering_rounded;
        break;
      case 'resolved':
        bg = const Color(0xFFF0FDF4); // Soft green
        text = const Color(0xFF15803D);
        border = const Color(0xFFBBF7D0);
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'closed':
      default:
        bg = const Color(0xFFF8FAFC); // Slate
        text = const Color(0xFF475569);
        border = const Color(0xFFE2E8F0);
        icon = Icons.archive_outlined;
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(
                color: text,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
