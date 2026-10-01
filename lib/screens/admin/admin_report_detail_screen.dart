import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/civic_report.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/location_map_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/timeline_widget.dart';

class AdminReportDetailScreen extends StatefulWidget {
  final CivicReport report;

  const AdminReportDetailScreen({super.key, required this.report});

  @override
  State<AdminReportDetailScreen> createState() => _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState extends State<AdminReportDetailScreen> {
  late CivicReport _report;
  bool _isUpdating = false;

  final List<String> _statusOptions = [
    'Submitted',
    'Under Review',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

  void _showUpdateStatusModal() {
    String selectedStatus = _report.status;
    final remarksController = TextEditingController();

    // Default suggested remark
    switch (_report.status.toLowerCase()) {
      case 'submitted':
        selectedStatus = 'Under Review';
        remarksController.text = 'Report verified by Ward Junior Engineer. Site inspection initiated.';
        break;
      case 'under review':
        selectedStatus = 'In Progress';
        remarksController.text = 'Contractor mobilized. Work order issued for physical repair.';
        break;
      case 'in progress':
        selectedStatus = 'Resolved';
        remarksController.text = 'Issue resolved on site and verified by municipal authority.';
        break;
      default:
        selectedStatus = _report.status;
        remarksController.text = 'Status updated by Municipal Authority.';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryNavy),
                        ),
                        const SizedBox(width: AppSpacing.sm + 2),
                        const Text(
                          'Update Report Status',
                          style: AppTextStyles.cardTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Report ID: ${_report.id} • Current: ${_report.status}',
                      style: AppTextStyles.supporting,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xs),

                    const Text(
                      'Select New Lifecycle Status',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Status Choices
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statusOptions.map((status) {
                        final isSelected = selectedStatus.toLowerCase() == status.toLowerCase();
                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: AppColors.primaryNavy,
                          backgroundColor: AppColors.surfaceMuted,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                selectedStatus = status;
                                if (status == 'Under Review') {
                                  remarksController.text = 'Report verified by Ward Junior Engineer. Site inspection scheduled.';
                                } else if (status == 'In Progress') {
                                  remarksController.text = 'Field contractor mobilized. Work order issued.';
                                } else if (status == 'Resolved') {
                                  remarksController.text = 'Physical repair completed and certified on site.';
                                } else if (status == 'Closed') {
                                  remarksController.text = 'Report closed following citizen verification period.';
                                } else {
                                  remarksController.text = 'Report returned to submitted state.';
                                }
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Remarks field
                    const Text(
                      'Official Remarks / Action Notes',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: remarksController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Enter official reason or field report notes...',
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.borderSubtle),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _confirmAndApplyStatusUpdate(selectedStatus, remarksController.text.trim());
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryNavy,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Proceed to Update'),
                          ),
                        ),
                      ],
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

  void _confirmAndApplyStatusUpdate(String newStatus, String remarks) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.primaryNavy, size: 22),
              SizedBox(width: 8),
              Text('Confirm Status Change', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to update the status of Report #${_report.id}?',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('From: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        StatusBadge(status: _report.status, compact: true),
                        const Text('  →  To: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        StatusBadge(status: newStatus, compact: true),
                      ],
                    ),
                    if (remarks.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Remarks: $remarks',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This change will be recorded in Cloud Firestore and will immediately update the citizen\'s tracking timeline.',
                style: AppTextStyles.metadata,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _executeStatusUpdate(newStatus, remarks);
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primaryNavy),
              child: const Text('Confirm & Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _executeStatusUpdate(String newStatus, String remarks) async {
    setState(() => _isUpdating = true);

    final reportProv = Provider.of<ReportProvider>(context, listen: false);
    final success = await reportProv.updateReportStatus(
      _report.id,
      newStatus,
      remarks.isNotEmpty ? remarks : 'Status advanced to $newStatus by civic authority.',
    );

    if (!mounted) return;
    setState(() => _isUpdating = false);

    if (success) {
      final updated = reportProv.allReports.firstWhere((r) => r.id == _report.id, orElse: () => _report);
      setState(() {
        _report = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report ${_report.id} updated to "$newStatus" successfully.'),
          backgroundColor: AppColors.secondaryTeal,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reportProv.errorMessage ?? 'Failed to update report status in Firestore.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Report #${_report.id}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: StatusBadge(status: _report.status, compact: true),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: SafeArea(
          child: AppButton(
            label: 'Update Report Status',
            icon: Icons.edit_note_rounded,
            isLoading: _isUpdating,
            onPressed: _showUpdateStatusModal,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _report.id,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavy,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          'Submitted: ${Formatters.formatDate(_report.createdAt)}',
                          style: AppTextStyles.metadata,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _report.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${_report.category}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 1. Citizen Information Section
              const SectionHeader(
                title: 'Citizen Information',
                subtitle: 'Applicant and contact details',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      icon: Icons.person_outline,
                      label: 'Applicant Name',
                      value: _report.userId.startsWith('citizen') ? 'Aarav Patel' : 'Registered Citizen (${_report.userId.substring(0, 6)})',
                    ),
                    const Divider(height: 16),
                    _infoRow(
                      icon: Icons.badge_outlined,
                      label: 'Citizen User ID',
                      value: _report.userId,
                    ),
                    const Divider(height: 16),
                    _infoRow(
                      icon: Icons.phone_outlined,
                      label: 'Contact Number',
                      value: '+91 98765 43210 (Verified)',
                    ),
                    const Divider(height: 16),
                    _infoRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Electoral Record',
                      value: 'Form 6 Enrolled • Ward 12 Voter',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Issue Description Section
              const SectionHeader(
                title: 'Issue Details',
                subtitle: 'Full statement submitted by citizen',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, size: 16, color: AppColors.primaryNavy),
                        const SizedBox(width: 6),
                        Text(
                          'Category: ${_report.category}',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primaryNavy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _report.description.isNotEmpty
                          ? _report.description
                          : 'No additional description notes were provided by the citizen.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: ${Formatters.formatDateTime(_report.updatedAt)}',
                      style: AppTextStyles.metadata,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. Location Section
              const SectionHeader(
                title: 'Location & Geo-Coordinates',
                subtitle: 'Incident site and municipal mapping',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.errorRed),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _report.location.isNotEmpty ? _report.location : 'Sector 10, Ward 12',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    if (_report.latitude != null && _report.longitude != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'GPS Coordinates: ${_report.latitude!.toStringAsFixed(4)}° N, ${_report.longitude!.toStringAsFixed(4)}° E',
                        style: AppTextStyles.metadata,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    LocationMapWidget(
                      latitude: _report.latitude ?? 19.0760,
                      longitude: _report.longitude ?? 72.8777,
                      locationName: _report.location.isNotEmpty ? _report.location : 'Sector 10',
                      height: 160,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. Evidence / Uploaded Image Section
              const SectionHeader(
                title: 'Evidence',
                subtitle: 'Site photograph uploaded by applicant',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: _buildEvidenceContent(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 5. Status Audit Trail / Timeline
              const SectionHeader(
                title: 'Status Timeline & Administrative Log',
                subtitle: 'Official record of municipal actions taken',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: ReportTimelineWidget(
                  history: _report.statusHistory,
                  currentStatus: _report.status,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceContent() {
    if (_report.imageUrl != null && _report.imageUrl!.isNotEmpty) {
      if (_report.imageUrl!.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _report.imageUrl!,
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _evidencePlaceholder(),
          ),
        );
      } else if (!kIsWeb) {
        final f = File(_report.imageUrl!);
        if (f.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              f,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        }
      }
    }
    return _evidencePlaceholder();
  }

  Widget _evidencePlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 28, color: AppColors.textMuted),
            SizedBox(height: 6),
            Text(
              'No photo attached to this report',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            SizedBox(height: 2),
            Text(
              'Grievance registered with textual description and GPS location',
              style: AppTextStyles.metadata,
            ),
          ],
        ),
      ),
    );
  }
}
