import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'event_registration_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final Function(RegistrationTicket) onTicketAdded;

  const HomeEventsScreen({
    super.key,
    required this.tickets,
    required this.onTicketAdded,
  });

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<EventItem> get _filteredEvents {
    return sampleEvents.where((event) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          event.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.speaker.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        onCategoryChanged: (cat) {
          setState(() => _selectedCategory = cat);
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'AI':
        return const Color(0xFF6C63FF);
      case 'Mobile':
        return const Color(0xFF00BFA5);
      case 'IoT':
        return const Color(0xFFFF6B35);
      case 'Cybersecurity':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredEvents;

    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seminar & Workshop',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${sampleEvents.length} event tersedia',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showFilterSheet,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                          ),
                        ),
                        tooltip: 'Filter',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Cari seminar atau pembicara...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF6C63FF),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Category chips
        Container(
          color: theme.colorScheme.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                'Semua',
                'AI',
                'Mobile',
                'IoT',
                'Cybersecurity',
              ].map((cat) {
                final isSelected = _selectedCategory == cat;
                final color = _getCategoryColor(cat);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = cat),
                    selectedColor: color.withValues(alpha: 0.2),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? color : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? color
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    showCheckmark: true,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Results count
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Row(
            children: [
              Text(
                '${filtered.length} event ditemukan',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (_selectedCategory != 'Semua') ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(_selectedCategory)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _selectedCategory,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getCategoryColor(_selectedCategory),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada event ditemukan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = 'Semua';
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        child: const Text('Reset Filter'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    return EventCard(
                      event: filtered[i],
                      onTap: () async {
                        final ticket = await Navigator.push<RegistrationTicket>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventRegistrationScreen(
                              event: filtered[i],
                            ),
                          ),
                        );
                        if (ticket != null) {
                          widget.onTicketAdded(ticket);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
