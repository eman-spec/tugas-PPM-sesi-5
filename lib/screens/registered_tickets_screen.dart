import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final Function(String ticketId) onTicketCancelled;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onTicketCancelled,
  });

  @override
  State<RegisteredTicketsScreen> createState() =>
      _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'AI':
        return Icons.psychology_rounded;
      case 'Mobile':
        return Icons.smartphone_rounded;
      case 'IoT':
        return Icons.device_hub_rounded;
      case 'Cybersecurity':
        return Icons.security_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Future<bool?> _confirmCancellation(RegistrationTicket ticket) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
            size: 32,
          ),
        ),
        title: const Text(
          'Batalkan Tiket?',
          style: TextStyle(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Anda akan membatalkan pendaftaran untuk:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    ticket.eventTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.ticketCode,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Tidak, Pertahankan'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeTickets =
        widget.tickets.where((t) => t.isActive).toList();

    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.secondary,
                theme.colorScheme.secondaryContainer,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiket Terdaftar',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${activeTickets.length} tiket aktif',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.confirmation_number_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Geser kiri info
        if (activeTickets.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.swipe_left_rounded,
                    color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Geser tiket ke kiri untuk membatalkan pendaftaran',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: activeTickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.confirmation_number_outlined,
                          size: 64,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Belum Ada Tiket',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daftarkan diri Anda ke seminar\ndan tiket akan muncul di sini',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  itemCount: activeTickets.length,
                  itemBuilder: (ctx, i) {
                    final ticket = activeTickets[i];
                    final color =
                        _getCategoryColor(ticket.eventCategory);

                    return Dismissible(
                      key: Key(ticket.ticketId),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        final confirmed =
                            await _confirmCancellation(ticket);
                        return confirmed ?? false;
                      },
                      onDismissed: (_) {
                        widget.onTicketCancelled(ticket.ticketId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.info_rounded,
                                    color: Colors.white),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Tiket ${ticket.ticketCode} telah dibatalkan',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red.shade700,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      background: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_rounded,
                                color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text(
                              'Batalkan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: color.withValues(alpha: 0.3),
                          ),
                          color: theme.colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Ticket top
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color.withValues(alpha: 0.15),
                                    color.withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(
                                          ticket.eventCategory),
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.green
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'AKTIF',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 10,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          ticket.ticketCode,
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.qr_code_rounded,
                                    color: color.withValues(alpha: 0.4),
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),

                            // Dashed separator
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Row(
                                children: List.generate(
                                  20,
                                  (i) => Expanded(
                                    child: Container(
                                      height: 1,
                                      color: i % 2 == 0
                                          ? color.withValues(alpha: 0.3)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Ticket details
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.eventTitle,
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  _TicketRow(
                                      icon: Icons.person_rounded,
                                      label: ticket.participantName,
                                      color: color),
                                  _TicketRow(
                                      icon: Icons.school_rounded,
                                      label: ticket.nim,
                                      color: color),
                                  _TicketRow(
                                      icon: Icons.calendar_today_rounded,
                                      label: ticket.attendanceDate,
                                      color: color),
                                  _TicketRow(
                                      icon: Icons.location_on_rounded,
                                      label: ticket.eventLocation,
                                      color: color),
                                  if (ticket.includeSeminarKit)
                                    _TicketRow(
                                        icon: Icons.shopping_bag_rounded,
                                        label: 'Seminar Kit ✓',
                                        color: color),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TicketRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TicketRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
