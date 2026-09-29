import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/polling_booth.dart';
import '../../providers/booth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/civic_card.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/map_placeholder_widget.dart';
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreenLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.directions, color: AppTheme.accentGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Directions to ${booth.boothNumber}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          Text(
                            booth.name,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.pin_drop, size: 16, color: AppTheme.primaryNavy),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booth.address,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                if (booth.landmark.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 16, color: AppTheme.accentAmber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Landmark: ${booth.landmark}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 8),
                    Text(
                      'Distance: ${Formatters.formatDistance(booth.distanceKm)} (~${(booth.distanceKm * 12).round()} min walk)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Simulated routing navigation to ${booth.name}. In production, launches GPS map provider.'),
                        duration: const Duration(seconds: 3),
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

    // Apply secondary filters
    final filteredBooths = boothProv.booths.where((b) {
      if (_onlyWheelchair && !b.wheelchairAccessible) return false;
      if (_onlyCloseProximity && b.distanceKm > 2.0) return false;
      return true;
    }).toList();

    final content = Column(
      children: [
        // Location Search, Filter and View Mode Switcher
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          color: AppTheme.surfaceWhite,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (val) => boothProv.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search polling station, address, or ward...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textMuted),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            boothProv.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              // Segmented Control: List View vs Map View
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
              const SizedBox(height: 8),

              // Quick Filter Chips (Wheelchair, < 2 km)
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
                      backgroundColor: AppTheme.surfaceMuted,
                      selectedColor: AppTheme.primaryNavy,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: (!_onlyWheelchair && !_onlyCloseProximity) ? Colors.white : AppTheme.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      avatar: const Icon(Icons.accessible, size: 14),
                      label: const Text('Wheelchair Accessible'),
                      selected: _onlyWheelchair,
                      onSelected: (val) {
                        setState(() {
                          _onlyWheelchair = val;
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: AppTheme.surfaceMuted,
                      selectedColor: AppTheme.primaryNavy,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onlyWheelchair ? Colors.white : AppTheme.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      avatar: const Icon(Icons.near_me_outlined, size: 14),
                      label: const Text('Within 2 km'),
                      selected: _onlyCloseProximity,
                      onSelected: (val) {
                        setState(() {
                          _onlyCloseProximity = val;
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: AppTheme.surfaceMuted,
                      selectedColor: AppTheme.primaryNavy,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onlyCloseProximity ? Colors.white : AppTheme.textSecondary,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        children: [
                          const InfoBanner(
                            text:
                                'Notice: Polling locations shown are sample educational data for project evaluation. On actual polling day, verify your designated booth on the official voter slip.',
                            type: BannerType.sampleData,
                          ),
                          const SizedBox(height: 14),

                          if (filteredBooths.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              alignment: Alignment.center,
                              child: const Column(
                                children: [
                                  Icon(Icons.location_off_outlined, size: 40, color: AppTheme.textMuted),
                                  SizedBox(height: 10),
                                  Text(
                                    'No polling booths found',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                                  ),
                                  SizedBox(height: 4),
                                  Text('Try clearing the active filters or search terms',
                                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                ],
                              ),
                            )
                          else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Designated Stations (${filteredBooths.length})',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                ),
                                const Text(
                                  'Sorted by nearest first',
                                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            ...filteredBooths.map((booth) => _buildBoothCard(context, booth)),
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
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Polling Booth Locator'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _buildBoothCard(BuildContext context, PollingBooth booth) {
    final walkMinutes = (booth.distanceKm * 12).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CivicCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booth Header: Booth Number and Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.where_to_vote, size: 20, color: AppTheme.primaryNavy),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booth.boothNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryNavy,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreenLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              Formatters.formatDistance(booth.distanceKm),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booth.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booth.address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Distance & Accessibility Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_walk, size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 3),
                      Text('~$walkMinutes min walk', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (booth.wheelchairAccessible)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.accessible, size: 12, color: AppTheme.textSecondary),
                        SizedBox(width: 4),
                        Text('Wheelchair Ramp', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Action Buttons: View Details & Directions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BoothDetailScreen(booth: booth)),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _showDirectionsModal(context, booth),
                  icon: const Icon(Icons.directions, size: 14),
                  label: const Text('Directions', style: TextStyle(fontSize: 12)),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
