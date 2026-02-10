import 'package:flutter/material.dart';
import '../../models/setting_item.dart';
import 'package:epiflipboard/pages/profile/connexion/auth_selection_page.dart';

class SettingsPage extends StatefulWidget {
  final List<SettingItem>? customSettings; // Optionnel, si null on utilise les paramètres par défaut

  const SettingsPage({super.key, this.customSettings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<SettingItem> _settings;
  bool pushNotifications = false;
  bool showMatureContent = false;

  @override
  void initState() {
    super.initState();
    _settings = widget.customSettings ?? _getDefaultSettings();
  }

  // Paramètres par défaut
  List<SettingItem> _getDefaultSettings() {
    return [
      SettingItem.header("Account Options"),
      // SettingItem.simple(
      //   title: "Sign up",
      //   subtitle: "for a new account",
      //   onTap: () => {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const AuthSelectionPage(isSignUp: true),
      //       ),
      //     ),
      //   },
      // ),
      // SettingItem.simple(
      //   title: "Log in",
      //   subtitle: "to your existing account",
      //   onTap: () => {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const AuthSelectionPage(isSignUp: false),
      //       ),
      //     )
      //   },
      // ),
      SettingItem.simple(
        title: "Erase all content and settings",
        onTap: () => _showEraseDialog(),
      ),
      
      SettingItem.header("Notifications"),
      SettingItem.withIcon(
        title: "Manage notifications",
        icon: Icons.help_outline,
        onTap: () => print("Manage notifications"),
      ),
      SettingItem.withSwitch(
        title: "Push Notifications",
        subtitle: "Get updates on the magazines, topics, and people you follow with notifications.",
        value: pushNotifications,
        onChanged: _onPushNotificationChanged,
      ),
      
      SettingItem.header("Display Options"),
      SettingItem.simple(
        title: "Browsing mode",
        subtitle: "Flip",
        onTap: () => print("Browsing mode"),
      ),
      SettingItem.withIcon(
        title: "Browsing mode",
        subtitle: "Flip",
        icon: Icons.help_outline,
        onTap: () => print("Browsing mode"),
      ),
      SettingItem.simple(
        title: "Theme",
        subtitle: "Dark",
        onTap: () => print("Theme"),
      ),
      SettingItem.withCheckbox(
        title: "Show mature content",
        subtitle: "May include sensitive or explicit content",
        value: showMatureContent,
        onChanged: _onMatureContentChanged,
      ),

      SettingItem.header("Content Options"),
      SettingItem.simple(
        title: "Muted sources",
        subtitle: "No sources muted",
        onTap: () => print("Muted sources"),
      ),
      SettingItem.simple(
        title: "Blocked profiles",
        onTap: () => print("Blocked profiles"),
      ),
      SettingItem.simple(
        title: "Add local content",
        onTap: () => print("Add local content"),
      ),
      SettingItem.withIcon(
        title: "Regional editions",
        subtitle: "Full use of mobile data",
        icon: Icons.help_outline,
        onTap: () => print("United States (English)"),
      ),

      SettingItem.header("Advanced"),
      SettingItem.simple(
        title: "Reduce data usage",
        subtitle: "Full use of mobile data",
        onTap: () => print("Reduce data usage"),
      ),
      SettingItem.withIcon(
        title: "Content cache",
        subtitle: "External, 128MB",
        icon: Icons.help_outline,
        onTap: () => print("Content cache"), // Handle cache
      ),

      SettingItem.header("About"),
      SettingItem.simple(
        title: "Help & Contact us",
        onTap: () => print("Help & Contact us"),
      ),
      SettingItem.simple(
        title: "About Flipboard",
        subtitle: "Flipboard 4.3.40, 5506", // Version flip
        onTap: () => print("About Flipboard"),
      ),
      SettingItem.simple(
        title: "Privacy policy",
        onTap: () => print("Privacy policy"),
      ),
    ];
  }

  void _showEraseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Erase All Data?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will delete all your content and settings. This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print("Data erased!");
            },
            child: const Text("Erase", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Méthode publique pour ajouter un paramètre dynamiquement
  void addSetting(SettingItem item) {
    setState(() {
      _settings.add(item);
    });
  }

  void _onPushNotificationChanged(bool val) {
    setState(() {
      pushNotifications = val;
      _updateSetting(
        title: "Push Notifications",
        newValue: val,
        type: SettingType.withSwitch,
      );
    });
  }

  void _onMatureContentChanged(bool val) {
    setState(() {
      showMatureContent = val;
      _updateSetting(
        title: "Show mature content",
        newValue: val,
        type: SettingType.withCheckbox,
      );
    });
  }

  void _updateSetting({
  required String title,
  required bool newValue,
  required SettingType type,
  }) {
    final index = _settings.indexWhere(
      (item) => item.title == title && item.type == type,
    );

    if (index == -1) return;

    final oldItem = _settings[index];

    if (type == SettingType.withSwitch) {
      _settings[index] = SettingItem.withSwitch(
        title: oldItem.title,
        subtitle: oldItem.subtitle!,
        value: newValue,
        onChanged: oldItem.onSwitchChanged!,
      );
    }

    if (type == SettingType.withCheckbox) {
      _settings[index] = SettingItem.withCheckbox(
        title: oldItem.title,
        subtitle: oldItem.subtitle,
        value: newValue,
        onChanged: oldItem.onCheckboxChanged!,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _settings.length,
        itemBuilder: (context, index) {
          return _buildSettingWidget(_settings[index]);
        },
      ),
    );
  }

  Widget _buildSettingWidget(SettingItem item) {
    switch (item.type) {
      case SettingType.header:
        return _buildSectionHeader(item.title);
      
      case SettingType.simple:
        return _buildSettingItem(
          title: item.title,
          subtitle: item.subtitle,
          onTap: item.onTap!,
        );
      
      case SettingType.withIcon:
        return _buildSettingItemWithIcon(
          title: item.title,
          icon: item.icon!,
          onTap: item.onTap!,
        );
      
      case SettingType.withSwitch:
        return _buildSwitchItem(
          title: item.title,
          subtitle: item.subtitle!,
          value: item.switchValue!,
          onChanged: item.onSwitchChanged!,
        );

      case SettingType.withCheckbox:
        return _buildCheckboxItem(
          title: item.title,
          subtitle: item.subtitle,
          value: item.checkboxValue!,
          onChanged: item.onCheckboxChanged!,
        );
      
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItemWithIcon({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(icon, color: Colors.white60, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            )
          : null,
      trailing: Checkbox(
        value: value,
        onChanged: (val) {
          if (val != null) {
            onChanged(val);
          }
        },
        activeColor: Colors.blue,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
