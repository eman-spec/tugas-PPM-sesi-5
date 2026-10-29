import 'package:flutter/material.dart';
import 'screens/home_events_screen.dart';
import 'screens/gallery_venue_screen.dart';
import 'screens/registered_tickets_screen.dart';
import 'models/registration_ticket.dart';

void main() {
  runApp(const NusaEventHubApp());
}

class NusaEventHubApp extends StatelessWidget {
  const NusaEventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaEvent Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final List<RegistrationTicket> _tickets = [];

  void _addTicket(RegistrationTicket ticket) {
    setState(() => _tickets.add(ticket));
  }

  void _cancelTicket(String ticketId) {
    setState(() {
      final idx = _tickets.indexWhere((t) => t.ticketId == ticketId);
      if (idx >= 0) _tickets[idx].isActive = false;
    });
  }

  int get _activeTicketCount =>
      _tickets.where((t) => t.isActive).length;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeEventsScreen(
        tickets: _tickets,
        onTicketAdded: _addTicket,
      ),
      const GalleryVenueScreen(),
      RegisteredTicketsScreen(
        tickets: _tickets,
        onTicketCancelled: _cancelTicket,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        elevation: 8,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event_rounded),
            label: 'Seminar',
          ),
          const NavigationDestination(
            icon: Icon(Icons.collections_outlined),
            selectedIcon: Icon(Icons.collections_rounded),
            label: 'Galeri',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _activeTicketCount > 0,
              label: Text('$_activeTicketCount'),
              child: const Icon(Icons.confirmation_number_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _activeTicketCount > 0,
              label: Text('$_activeTicketCount'),
              child: const Icon(Icons.confirmation_number_rounded),
            ),
            label: 'Tiket',
          ),
        ],
      ),
    );
  }
}
