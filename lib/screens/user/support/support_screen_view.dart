import 'package:flutter/material.dart';

import '../../../widgets/general/gradient_icon_button.dart';
import '../../../widgets/general/gradient_text.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const GradientText(text: 'Support'),
        leading: GradientIconButton(
          icon: Icons.chevron_left,
          onPressed: () {
            Navigator.pop(context);
          },
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Members of teams',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildContactItem(
              icon: Icons.people_outlined,
              title: 'Tô Vĩnh Tiến',
              subtitle: '22521474',
              onTap: () {},
            ),
            _buildContactItem(
              icon: Icons.people_outlined,
              title: 'Đỗ Hồng Quân',
              subtitle: '22521175',
              onTap: () {},
            ),
            _buildContactItem(
              icon: Icons.people_outlined,
              title: 'Trần Nhật Tân',
              subtitle: '22521312',
              onTap: () {},
            ),
            _buildContactItem(
              icon: Icons.people_outlined,
              title: 'Nguyễn Duy Vũ',
              subtitle: '22521693',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon, 
          size: 32,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
} 