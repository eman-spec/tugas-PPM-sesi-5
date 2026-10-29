import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tugas_sesi_5/main.dart';
import 'package:tugas_sesi_5/models/event_item.dart';
import 'package:tugas_sesi_5/models/registration_ticket.dart';
import 'package:tugas_sesi_5/data/sample_events.dart';
import 'package:tugas_sesi_5/screens/event_registration_screen.dart';
import 'package:tugas_sesi_5/widgets/event_card.dart';
import 'package:tugas_sesi_5/widgets/filter_bottom_sheet.dart';
import 'package:tugas_sesi_5/widgets/venue_map_viewer.dart';

void main() {
  group('1. Model Unit Tests', () {
    test('EventItem properties and calculated getters', () {
      final event = EventItem(
        id: 'test_evt_1',
        title: 'Mastering Flutter UI/UX',
        speaker: 'Dr. Jane Doe',
        category: 'Mobile',
        date: '25 Des 2026',
        time: '09:00 - 12:00 WIB',
        location: 'Auditorium Utama',
        description: 'Belajar desain modern Flutter',
        imageUrl: 'assets/images/placeholder.png',
        capacity: 100,
        registered: 80,
        price: 0,
      );

      expect(event.isAvailable, isTrue);
      expect(event.availableSlots, equals(20));
      expect(event.occupancyRate, closeTo(0.8, 0.001));

      // Test full capacity
      final fullEvent = EventItem(
        id: 'test_evt_2',
        title: 'Full Event',
        speaker: 'Speaker',
        category: 'AI',
        date: '26 Des 2026',
        time: '10:00 WIB',
        location: 'Lab A',
        description: 'Desc',
        imageUrl: 'assets/images/placeholder.png',
        capacity: 50,
        registered: 50,
        price: 0,
      );
      expect(fullEvent.isAvailable, isFalse);
      expect(fullEvent.availableSlots, equals(0));
      expect(fullEvent.occupancyRate, equals(1.0));

      // Test zero capacity edge case
      final zeroCapEvent = EventItem(
        id: 'test_evt_3',
        title: 'Zero Cap',
        speaker: 'Speaker',
        category: 'IoT',
        date: '27 Des 2026',
        time: '10:00 WIB',
        location: 'Lab B',
        description: 'Desc',
        imageUrl: 'assets/images/placeholder.png',
        capacity: 0,
        registered: 0,
        price: 0,
      );
      expect(zeroCapEvent.occupancyRate, equals(0.0));
    });

    test('RegistrationTicket cost calculations and ticket code generation', () {
      final ticket = RegistrationTicket(
        ticketId: 'A1B2C3D4',
        eventId: 'evt001',
        eventTitle: 'AI Workshop',
        eventCategory: 'AI',
        eventDate: '15 Nov 2025',
        eventTime: '09:00 WIB',
        eventLocation: 'Aula Utama',
        participantName: 'Soleeman Firdaus Ode',
        nim: 'IF31033001',
        email: 'soleeman@example.com',
        whatsapp: '081234567890',
        participantType: 'Mahasiswa',
        attendanceDate: '15 Nov 2025',
        includeSeminarKit: true,
        donationAmount: 50000,
        registeredAt: DateTime.now(),
      );

      // Total cost: 50000 donation + 25000 kit = 75000
      expect(ticket.totalCost, equals(75000));
      expect(ticket.isActive, isTrue);
      expect(ticket.ticketCode, equals('NSE-A1B2C3-AI'));

      // Ticket without kit
      final ticketNoKit = RegistrationTicket(
        ticketId: '12345678',
        eventId: 'evt002',
        eventTitle: 'Flutter Lab',
        eventCategory: 'Mobile',
        eventDate: '16 Nov 2025',
        eventTime: '13:00 WIB',
        eventLocation: 'Lab 3',
        participantName: 'Budi Santoso',
        nim: 'IF31033002',
        email: 'budi@example.com',
        whatsapp: '081234567891',
        participantType: 'Mahasiswa',
        attendanceDate: '16 Nov 2025',
        includeSeminarKit: false,
        donationAmount: 0,
        registeredAt: DateTime.now(),
      );
      expect(ticketNoKit.totalCost, equals(0));
      expect(ticketNoKit.ticketCode, equals('NSE-123456-MO'));
    });

    test('sampleEvents data sanity check', () {
      expect(sampleEvents.length, greaterThanOrEqualTo(6));
      for (final event in sampleEvents) {
        expect(event.id, isNotEmpty);
        expect(event.title, isNotEmpty);
        expect(event.speaker, isNotEmpty);
        expect(event.category, isNotEmpty);
        expect(event.capacity, greaterThan(0));
      }
    });
  });

  group('2. Widget & Navigation Tests', () {
    testWidgets('Initial render of NusaEventHubApp & Home tab',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const NusaEventHubApp());
      await tester.pumpAndSettle();

      // Verify app bar / header in Home
      expect(find.text('Seminar & Workshop'), findsOneWidget);
      expect(find.text('Seminar'), findsOneWidget);
      expect(find.text('Galeri'), findsOneWidget);
      expect(find.text('Tiket'), findsOneWidget);

      // Verify Search TextField
      expect(find.byType(TextField), findsOneWidget);

      // Verify category chips
      expect(find.text('Semua'), findsWidgets);
      expect(find.text('AI'), findsWidgets);
      expect(find.text('Mobile'), findsWidgets);

      // Verify event cards rendered
      expect(find.byType(EventCard), findsWidgets);
    });

    testWidgets('Search query filtering on Home screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const NusaEventHubApp());
      await tester.pumpAndSettle();

      // Enter search term 'Flutter'
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Flutter');
      await tester.pumpAndSettle();

      // Should find the Flutter event
      expect(find.textContaining('Flutter'), findsWidgets);

      // Non-matching events should not appear
      expect(find.text('Internet of Things: Bangun Smart Home System'),
          findsNothing);

      // Clear search
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Verification: multiple event cards are visible again
      expect(find.byType(EventCard), findsWidgets);
    });

    testWidgets('Bottom navigation tab switching to Galeri and Tiket',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const NusaEventHubApp());
      await tester.pumpAndSettle();

      // Switch to Galeri tab
      await tester.tap(find.text('Galeri'));
      await tester.pumpAndSettle();

      // Verify Galeri & Denah Venue header
      expect(find.text('Galeri & Denah Venue'), findsOneWidget);
      expect(find.text('Galeri Poster'), findsOneWidget);
      expect(find.text('Denah Venue'), findsOneWidget);

      // Tap on a poster to open detail dialog
      final posterTitle = find.text('AI & Machine Learning');
      expect(posterTitle, findsOneWidget);
      await tester.tap(posterTitle);
      await tester.pumpAndSettle();

      // Verify poster dialog opened
      expect(find.text('Tutup'), findsOneWidget);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      // Switch to Denah Venue sub-tab
      await tester.tap(find.text('Denah Venue'));
      await tester.pumpAndSettle();

      // Verify VenueMapViewer is rendered
      expect(find.byType(VenueMapViewer), findsOneWidget);
      expect(find.text('Denah Venue'), findsWidgets);
      expect(find.text('Lokasi Event'), findsOneWidget);

      // Switch to Tiket tab
      await tester.tap(find.text('Tiket'));
      await tester.pumpAndSettle();

      // Verify empty tickets state
      expect(find.text('Belum Ada Tiket'), findsOneWidget);
      expect(find.text('Tiket Terdaftar'), findsOneWidget);
    });

    testWidgets('Filter bottom sheet open and apply',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const NusaEventHubApp());
      await tester.pumpAndSettle();

      // Tap filter icon
      final filterIcon = find.byTooltip('Filter');
      expect(filterIcon, findsOneWidget);
      await tester.tap(filterIcon);
      await tester.pumpAndSettle();

      // Bottom sheet visible with categories
      expect(find.text('Filter Kategori'), findsOneWidget);
      expect(find.text('Terapkan Filter'), findsOneWidget);

      // Select AI category inside the bottom sheet and apply
      final aiOption = find.descendant(
        of: find.byType(FilterBottomSheet),
        matching: find.text('AI'),
      );
      expect(aiOption, findsOneWidget);
      await tester.tap(aiOption);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Terapkan Filter'));
      await tester.pumpAndSettle();

      // Bottom sheet dismissed
      expect(find.text('Filter Kategori'), findsNothing);
    });

    testWidgets('EventRegistrationScreen renders form components correctly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testEvent = sampleEvents.first;
      await tester.pumpWidget(
        MaterialApp(
          home: EventRegistrationScreen(event: testEvent),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title & section headers
      expect(find.text('Formulir Pendaftaran'), findsOneWidget);
      expect(find.text('Data Peserta'), findsOneWidget);
      expect(find.text('Informasi Kehadiran'), findsOneWidget);
      expect(find.text('Paket & Donasi'), findsOneWidget);
      expect(find.text('Persetujuan Tata Tertib'), findsOneWidget);

      // Verify form fields
      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('NIM'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Nomor WhatsApp'), findsOneWidget);

      // Verify choices and switches
      expect(find.text('Mahasiswa'), findsOneWidget);
      expect(find.text('Dosen'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text('Seminar Kit'), findsWidgets);
      expect(find.text('Daftarkan Sekarang'), findsOneWidget);
    });
  });
}
