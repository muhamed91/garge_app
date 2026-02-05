import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Container(
        color: Colors.grey.shade100,
        child: ListView(
          children: [
            _SectionHeader(title: "Allgemein"),
            _SettingsTile(
              icon: Icons.language,
              title: "Sprache",
              subtitle: "Deutsch",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              subtitle: "System",
              onTap: () {},
            ),

            const Divider(),

            _SectionHeader(title: "Account"),
            _SettingsTile(icon: Icons.person, title: "Profil", onTap: () {}),
            _SettingsTile(
              icon: Icons.lock,
              title: "Passwort ändern",
              onTap: () {},
            ),

            const Divider(),

            _SectionHeader(title: "App"),
            _SettingsTile(
              icon: Icons.info_outline,
              title: "Über die App",
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Garage App",
                  applicationVersion: "1.0.0",
                );
              },
            ),
            _SettingsTile(
              icon: Icons.logout,
              title: "Abmelden",
              titleColor: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/* -----------------------------
   REUSABLE WIDGETS
-------------------------------- */

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
