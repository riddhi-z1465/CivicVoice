import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../services/location_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import 'report_detail_screen.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  final LocationService _locationService = LocationService();
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedCategory = AppConstants.issueCategories.first; // Road
  XFile? _selectedImage;
  bool _isFetchingLocation = false;
  double? _latitude;
  double? _longitude;

  final Map<String, IconData> _categoryIcons = {
    'Road': Icons.add_road_outlined,
    'Street Light': Icons.lightbulb_outline,
    'Garbage': Icons.delete_outline,
    'Water Supply': Icons.water_drop_outlined,
    'Public Safety': Icons.security_outlined,
    'Drainage': Icons.waves_outlined,
    'Traffic': Icons.traffic_outlined,
    'Other': Icons.report_problem_outlined,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = picked;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open image picker: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    final pos = await _locationService.getCurrentPosition();
    setState(() {
      _latitude = pos['latitude'] as double;
      _longitude = pos['longitude'] as double;
      _locationController.text = pos['address'] as String;
      _isFetchingLocation = false;
    });
  }

  void _showManualLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Select Municipal Ward / Area',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                ...LocationService.municipalLocations.map((loc) {
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: AppTheme.primaryNavy),
                    title: Text(loc['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(loc['address'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    onTap: () {
                      setState(() {
                        _latitude = loc['lat'] as double;
                        _longitude = loc['lng'] as double;
                        _locationController.text = loc['address'] as String;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final reportProv = Provider.of<ReportProvider>(context, listen: false);

    final userId = auth.user?.uid ?? 'citizen-demo-01';

    final submitted = await reportProv.submitReport(
      userId: userId,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      imageUrl: _selectedImage?.path,
      imageFile: _selectedImage,
    );

    if (!mounted) return;

    if (submitted != null) {
      _showConfirmationDialog(submitted);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reportProv.errorMessage ?? 'Submission failed. Please try again.'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _showConfirmationDialog(dynamic report) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.accentGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppTheme.accentGreen, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Report Registered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report submitted successfully.\nYour issue has been logged into the municipal grievance register.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.35),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Report ID: ${report.id}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryNavy),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 14),
                          tooltip: 'Copy Report ID',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: report.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Report ID copied to clipboard'), duration: Duration(seconds: 1)),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${report.status}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accentGreen),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Category: ${report.category}',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ReportDetailScreen(report: report)),
                );
              },
              child: const Text('Track Report Status'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProv = Provider.of<ReportProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Report Civic Issue'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instruction Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSubtle),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: AppTheme.primaryNavy),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Provide factual details and precise locality to ensure rapid municipal triage and dispatch.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Category Selection Chips Grid
                const Text(
                  'Select Issue Category *',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.issueCategories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    final icon = _categoryIcons[cat] ?? Icons.report_problem_outlined;

                    return ChoiceChip(
                      avatar: Icon(
                        icon,
                        size: 15,
                        color: isSelected ? Colors.white : AppTheme.primaryNavy,
                      ),
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                      selectedColor: AppTheme.primaryNavy,
                      backgroundColor: AppTheme.surfaceWhite,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryNavy : AppTheme.borderSubtle,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Issue Title
                const Text(
                  'Issue Title *',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  validator: (v) => Validators.minLength(v, 5, 'Title'),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Broken Water Pipeline on Station Road',
                    prefixIcon: Icon(Icons.title, size: 18, color: AppTheme.textMuted),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field (Multiline)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detailed Description *',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const Text(
                      'Min 15 characters',
                      style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  validator: (v) => Validators.minLength(v, 15, 'Description'),
                  decoration: const InputDecoration(
                    hintText: 'Describe the problem, severity, duration, and any safety hazards...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Location Field & Action Buttons
                const Text(
                  'Location / Landmark *',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _locationController,
                  validator: (v) => Validators.requiredField(v, 'Location'),
                  decoration: InputDecoration(
                    hintText: 'Street name, ward, landmark...',
                    prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: AppTheme.textMuted),
                    suffixIcon: _isFetchingLocation
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isFetchingLocation ? null : _useCurrentLocation,
                      icon: const Icon(Icons.my_location, size: 14),
                      label: const Text('Use Current GPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _showManualLocationPicker,
                      icon: const Icon(Icons.map, size: 14),
                      label: const Text('Select Ward Area', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Image Upload / Preview Section
                const Text(
                  'Attach Evidence Photo (Optional)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 6),

                if (_selectedImage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderSubtle),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: kIsWeb
                              ? Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: AppTheme.surfaceMuted,
                                  child: const Center(
                                    child: Icon(Icons.image, size: 40, color: AppTheme.primaryNavy),
                                  ),
                                )
                              : Image.file(
                                  File(_selectedImage!.path),
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedImage!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.delete_outline, size: 14, color: Color(0xFFDC2626)),
                              label: const Text('Remove Photo', style: TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined, size: 16),
                          label: const Text('Take Photo', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                          label: const Text('Choose File', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 28),

                // Submit Button
                FilledButton(
                  onPressed: reportProv.isLoading ? null : _submitReport,
                  child: reportProv.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Submit Civic Issue Report'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
