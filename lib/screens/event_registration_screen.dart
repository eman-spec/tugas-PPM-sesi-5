import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import 'dart:math';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _donationController = TextEditingController(text: '0');

  String _participantType = 'Mahasiswa';
  DateTime? _attendanceDate;
  bool _includeSeminarKit = false;
  bool _agreeToRules = false;
  bool _isLoading = false;

  final List<String> _participantTypes = [
    'Mahasiswa',
    'Dosen',
    'Profesional',
    'Umum',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _donationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Pilih Tanggal Kehadiran',
      confirmText: 'Pilih',
      cancelText: 'Batal',
    );
    if (picked != null) {
      setState(() => _attendanceDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_attendanceDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Pilih tanggal kehadiran terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!_agreeToRules) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Harap setujui tata tertib acara'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final ticket = RegistrationTicket(
      ticketId: _generateTicketId(),
      eventId: widget.event.id,
      eventTitle: widget.event.title,
      eventCategory: widget.event.category,
      eventDate: widget.event.date,
      eventTime: widget.event.time,
      eventLocation: widget.event.location,
      participantName: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      participantType: _participantType,
      attendanceDate: _formatDate(_attendanceDate!),
      includeSeminarKit: _includeSeminarKit,
      donationAmount: double.tryParse(_donationController.text) ?? 0,
      registeredAt: DateTime.now(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '🎉 Pendaftaran berhasil! Kode tiket: ${ticket.ticketCode}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context, ticket);
    }
  }

  String _generateTicketId() {
    final rng = Random();
    return List.generate(8, (_) => rng.nextInt(16).toRadixString(16))
        .join()
        .toUpperCase();
  }

  Color get _categoryColor {
    switch (widget.event.category) {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Formulir Pendaftaran',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.event.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _categoryColor.withValues(alpha: 0.5),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 56, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.event.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.event.date} • ${widget.event.location}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: 'Data Peserta',
                      icon: Icons.person_rounded,
                      color: _categoryColor,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nama Lengkap',
                          hint: 'Masukkan nama lengkap Anda',
                          icon: Icons.badge_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            if (v.trim().length < 3) {
                              return 'Nama minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nimController,
                          label: 'NIM',
                          hint: 'Contoh: IF31033XXXX',
                          icon: Icons.school_rounded,
                          keyboardType: TextInputType.text,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'NIM tidak boleh kosong';
                            }
                            if (v.trim().length < 5) {
                              return 'NIM tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'contoh@email.com',
                          icon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(v.trim())) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _whatsappController,
                          label: 'Nomor WhatsApp',
                          hint: '08xxxxxxxxxx',
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Nomor WhatsApp tidak boleh kosong';
                            }
                            if (v.trim().length < 10 ||
                                v.trim().length > 13) {
                              return 'Nomor WhatsApp harus 10-13 digit';
                            }
                            if (!v.startsWith('08') &&
                                !v.startsWith('62')) {
                              return 'Awali dengan 08 atau 62';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _SectionCard(
                      title: 'Informasi Kehadiran',
                      icon: Icons.event_available_rounded,
                      color: _categoryColor,
                      children: [
                        // Participant type
                        Text(
                          'Tipe Peserta',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _participantTypes.map((type) {
                            final isSelected = _participantType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSelected,
                              onSelected: (_) =>
                                  setState(() => _participantType = type),
                              selectedColor:
                                  _categoryColor.withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? _categoryColor
                                    : theme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? _categoryColor
                                    : theme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              checkmarkColor: _categoryColor,
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Date picker
                        Text(
                          'Tanggal Kehadiran',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _attendanceDate != null
                                    ? _categoryColor
                                    : theme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                width: _attendanceDate != null ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: _attendanceDate != null
                                  ? _categoryColor.withValues(alpha: 0.05)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: _attendanceDate != null
                                      ? _categoryColor
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _attendanceDate != null
                                      ? _formatDate(_attendanceDate!)
                                      : 'Pilih tanggal kehadiran',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: _attendanceDate != null
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                    fontWeight: _attendanceDate != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _SectionCard(
                      title: 'Paket & Donasi',
                      icon: Icons.card_giftcard_rounded,
                      color: _categoryColor,
                      children: [
                        // Seminar kit
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _includeSeminarKit
                                  ? _categoryColor
                                  : theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                              width: _includeSeminarKit ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _includeSeminarKit
                                ? _categoryColor.withValues(alpha: 0.05)
                                : Colors.transparent,
                          ),
                          child: SwitchListTile(
                            value: _includeSeminarKit,
                            onChanged: (v) =>
                                setState(() => _includeSeminarKit = v),
                            title: const Text(
                              'Seminar Kit',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              'Tas, notebook, pulpen, & sertifikat (Rp 25.000)',
                            ),
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _categoryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: _categoryColor,
                              ),
                            ),
                            activeThumbColor: _categoryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Donation
                        _buildTextField(
                          controller: _donationController,
                          label: 'Donasi Sukarela (Rp)',
                          hint: '0',
                          icon: Icons.favorite_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final amount = int.tryParse(v) ?? 0;
                            if (amount < 0) return 'Donasi tidak boleh negatif';
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Cost summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _categoryColor.withValues(alpha: 0.1),
                                _categoryColor.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _categoryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              _CostRow(
                                label: 'Seminar Kit',
                                value: _includeSeminarKit
                                    ? 'Rp 25.000'
                                    : 'Tidak',
                                color: _categoryColor,
                              ),
                              const SizedBox(height: 8),
                              _CostRow(
                                label: 'Donasi',
                                value:
                                    'Rp ${_donationController.text.isEmpty ? "0" : _donationController.text}',
                                color: _categoryColor,
                              ),
                              const Divider(height: 16),
                              _CostRow(
                                label: 'Total',
                                value:
                                    'Rp ${(_includeSeminarKit ? 25000 : 0) + (int.tryParse(_donationController.text) ?? 0)}',
                                color: _categoryColor,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tata tertib
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: _agreeToRules
                              ? _categoryColor
                              : theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: _agreeToRules ? 2 : 1,
                        ),
                      ),
                      color: _agreeToRules
                          ? _categoryColor.withValues(alpha: 0.05)
                          : null,
                      child: CheckboxListTile(
                        value: _agreeToRules,
                        onChanged: (v) =>
                            setState(() => _agreeToRules = v ?? false),
                        title: const Text(
                          'Persetujuan Tata Tertib',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                          'Saya menyetujui untuk mengikuti semua aturan acara, hadir tepat waktu, dan menjaga ketertiban selama kegiatan berlangsung.',
                        ),
                        activeColor: _categoryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _submitRegistration,
                        style: FilledButton.styleFrom(
                          backgroundColor: _categoryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Mendaftar...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.how_to_reg_rounded),
                                  SizedBox(width: 10),
                                  Text(
                                    'Daftarkan Sekarang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _categoryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _categoryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _CostRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                color: isBold
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? color : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
