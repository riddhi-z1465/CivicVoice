import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/civic_report.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/timeline_widget.dart';

class ReportDetailScreen extends StatefulWidget {
  final CivicReport report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late CivicReport _currentReport;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.report;
  }

  void _showStatusProgressionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.science_outlined, size: 20, color: AppTheme.primaryNavy),
                    SizedBox(width: 8),
                    Text(
                      'Viva Demo: Update Report Lifecycle',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select a status stage to simulate municipal officer triage during project evaluation:',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 14),
                const Divider(),
                _statusOptionTile(
                  status: 'Under Review',
                  remarks: 'Assigned to Ward Junior Engineer for preliminary site survey.',
                  ctx: ctx,
                ),
                _statusOptionTile(
                  status: 'In Progress',
                  remarks: 'Work order #WO-902 issued. Repair team mobilized on site.',
                  ctx: ctx,
                ),
                _statusOptionTile(
                  status: 'Resolved',
                  remarks: 'Physical inspection completed. Grievance closed with citizen verification.',
                  ctx: ctx,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusOptionTile({
    required String status,
    required String remarks,
    required BuildContext ctx,
  }) {
    return ListTile(
      leading: StatusChip(status: status, compact: true),
      title: Text('Advance to $status', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(remarks, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      onTap: () async {
        Navigator.pop(ctx);
        final prov = Provider.of<ReportProvider>(context, listen: false);
        final success = await prov.advanceStatus(_currentReport.id, status, remarks);
        if (success && mounted) {
          final updated = prov.allReports.firstWhere((r) => r.id == _currentReport.id);
          setState(() {
            _currentReport = updated;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report ${_currentReport.id} transitioned to $status'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(_currentReport.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Simulate Status Progression (Demo)',
            onPressed: _showStatusProgressionModal,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Text(
                            _currentReport.category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        StatusChip(status: _currentReport.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentReport.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _currentReport.location,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Submitted on ${Formatters.formatDateTime(_currentReport.createdAt)}',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Card
              const Text(
                'Issue Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Text(
                  _currentReport.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Attached Photo if available
              if (_currentReport.imageUrl != null) ...[
                const Text(
                  'Attached Citizen Evidence',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: kIsWeb || !_currentReport.imageUrl!.startsWith('/')
                        ? Container(
                            height: 180,
                            color: AppTheme.surfaceMuted,
                            child: const Center(
                              child: Icon(Icons.image, size: 40, color: AppTheme.textMuted),
                            ),
                          )
                        : Image.file(
                            File(_currentReport.imageUrl!),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Lifecycle Progress Timeline
              const Text(
                'Grievance Resolution Lifecycle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: ReportTimelineWidget(
                  history: _currentReport.statusHistory,
                  currentStatus: _currentReport.status,
                ),
              ),
              const SizedBox(height: 20),

              // Demo helper note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Demo feature: Tap the settings icon in the top right to simulate lifecycle progression for viva presentation.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ),
                    TextButton(
                      onPressed: _showStatusProgressionModal,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Update', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
