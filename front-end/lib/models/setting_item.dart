import 'package:flutter/material.dart';

enum SettingType { simple, withSubtitle, withCheckbox, withIcon, withSwitch, header }

class SettingItem {
  final SettingType type;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool? checkboxValue;                 // ✅
  final ValueChanged<bool>? onCheckboxChanged; // ✅

  SettingItem({
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.checkboxValue,
    this.onCheckboxChanged,
  });

  // Constructeurs nommés pour faciliter la création
  SettingItem.header(String title)
      : type = SettingType.header,
        title = title,
        subtitle = null,
        icon = null,
        onTap = null,
        switchValue = null,
        onSwitchChanged = null,
        checkboxValue = null,
        onCheckboxChanged = null;

  SettingItem.simple({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  })  : type = SettingType.simple,
        title = title,
        subtitle = subtitle,
        icon = null,
        onTap = onTap,
        switchValue = null,
        onSwitchChanged = null,
        checkboxValue = null,
        onCheckboxChanged = null;

  SettingItem.withIcon({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  })  : type = SettingType.withIcon,
        title = title,
        subtitle = null,
        icon = icon,
        onTap = onTap,
        switchValue = null,
        onSwitchChanged = null,
        checkboxValue = null,
        onCheckboxChanged = null;

  SettingItem.withSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  })  : type = SettingType.withSwitch,
        title = title,
        subtitle = subtitle,
        icon = null,
        onTap = null,
        switchValue = value,
        onSwitchChanged = onChanged,
        checkboxValue = null,
        onCheckboxChanged = null;

  SettingItem.withCheckbox({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  })  : type = SettingType.withCheckbox,
        title = title,
        subtitle = subtitle,
        icon = null,
        onTap = null,
        switchValue = null,
        onSwitchChanged = null,
        checkboxValue = value,
        onCheckboxChanged = onChanged;
}