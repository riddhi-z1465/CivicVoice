import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/polling_booth.dart';
import '../../providers/booth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/map_placeholder_widget.dart';
import '../../widgets/polling_booth_card.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import 'booth_detail_screen.dart';

class PollingBoothScreen extends StatefulWidget {
  final bool isEmbedded;

  const PollingBoothScreen({super.key, this.isEmbedded = false});

  @override
  State<PollingBoothScreen> createState() => _PollingBoothScreenState();
}

class _PollingBoothScreenState extends State<PollingBoothScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _onlyWheelchair = false;
  bool _onlyCloseProximity = false; // < 2 km

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDirectionsModal(BuildContext context, PollingBooth booth) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.directions, color: AppColors.secondaryDark, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Directions to ${booth.boothNumber}',
                            style: AppTextStyles.cardTitle,
                          ),
                          Text(
                            booth.name,
                            style: AppTextStyles.supporting,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16, color: AppColors.primaryNavy),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        booth.address,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                if (booth.landmark.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs + 2),
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 16, color: AppColors.warningAmber),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Landmark: ${booth.landmark}',
                          style: AppTextStyles.supporting,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.sm + 2),
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Distance: ${Formatters.formatDistance(booth.distanceKm)} (~${(booth.distanceKm * 12).round()} min walk)',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Simulated routing navigation to ${booth.name}.'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Start Turn-by-Turn Navigation'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final boothProv = Provider.of<BoothProvider>(context);

    final filteredBooths = boothProv.booths.where((b) {
      if (_onlyWheelchair && !b.wheelchairAccessible) return false;
      if (_onlyCloseProximity && b.distanceKm > 2.0) return false;
      return true;
    }).toList();

    final content = Column(
      children: [
        // Top Search and View Switcher Header
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          color: AppColors.surfaceWhite,
          child: Column(
            children: [
              CivicSearchField(
                controller: _searchController,
                hintText: 'Search polling station, address, or ward...',
                onChanged: (val) => boothProv.setSearchQuery(val),
              ),
              const SizedBox(height: AppSpacing.sm),

              // View Mode Toggle (List View vs Map View) & Filters
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<BoothViewMode>(
                      segments: const [
                        ButtonSegment(
                          value: BoothViewMode.list,
                          icon: Icon(Icons.list_alt, size: 16),
                          label: Text('List View', style: TextStyle(fontSize: 12)),
                        ),
                        ButtonSegment(
                          value: BoothViewMode.map,
                          icon: Icon(Icons.map_outlined, size: 16),
                          label: Text('Map View', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      selected: {boothProv.viewMode},
                      onSelectionChanged: (Set<BoothViewMode> selection) {
                        boothProv.setViewMode(selection.first);
                      },
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs + 2),

              // Quick Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Booths'),
                      selected: !_onlyWheelchair && !_onlyCloseProximity,
                      onSelected: (_) {
                        setState(() {
                          _onlyWheelchair = false;
                          _onlyCloseProximity = false;
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: AppColors.surfaceMuted,
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: (!_onlyWheelchair && !_onlyCloseProximity)
                            ? AppColors.primaryNavy
                            : AppColors.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    FilterChip(
                      avatar: const Icon(Icons.accessible, size: 13),
                      label: const Text('Wheelchair Accessible'),
                      selected: _onlyWheelchair,
                      onSelected: (val) {
                        setState(() {
                          _onlyWheelchair = val;
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: AppColors.surfaceMuted,
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onlyWheelchair ? AppColors.primaryNavy : AppColors.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    FilterChip(
                      avatar: const Icon(Icons.near_me_outlined, size: 13),
                      label: const Text('Within 2 km'),
                      selected: _onlyCloseProximity,
                      onSelected: (val) {
                        setState(() {
                          _onlyCloseProximity = val;
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: AppColors.surfaceMuted,
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onlyCloseProximity ? AppColors.primaryNavy : AppColors.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Body: Toggle between List View and Map Canvas
        Expanded(
          child: boothProv.isLoading
              ? const Center(child: CircularProgressIndicator())
              : boothProv.viewMode == BoothViewMode.map
                  ? MapPlaceholderWidget(
                      booths: filteredBooths,
                      selectedBooth: boothProv.selectedBooth,
                      onSelectBooth: (b) => boothProv.selectBooth(b),
                      onDetailsTap: () {
                        if (boothProv.selectedBooth != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BoothDetailScreen(booth: boothProv.selectedBooth!),
                            ),
                          );
                        }
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: () => boothProv.loadBooths(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        children: [
                          const InfoBanner(
                            text:
                                'Notice: Booth locations shown are sample educational data for project evaluation. Verify your assigned station on your official voter slip.',
                            type: BannerType.sampleData,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          if (filteredBooths.isEmpty)
                            EmptyState(
                              icon: Icons.location_off_outlined,
                              title: 'No polling booths found',
                              description: 'Try clearing active filters or modifying search keywords.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                setState(() {
                                  _onlyWheelchair = false;
                                  _onlyCloseProximity = false;
                                  _searchController.clear();
                                  boothProv.setSearchQuery('');
                                });
                              },
                            )
                          else ...[
                            SectionHeader(
                              title: 'Nearby Polling Booths',
                              subtitle: '${filteredBooths.length} stations found • Sorted by nearest',
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            ...filteredBooths.map((booth) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                  child: PollingBoothCard(
                                    booth: booth,
                                    onDetailsTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BoothDetailScreen(booth: booth),
                                        ),
                                      );
                                    },
                                    onDirectionsTap: () => _showDirectionsModal(context, booth),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
        ),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Polling Booths'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}
