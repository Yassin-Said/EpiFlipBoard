import 'package:epiflipboard/models/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingItem', () {
    test('header constructor sets type and title correctly', () {
      final item = SettingItem.header('Header Title');

      expect(item.type, SettingType.header);
      expect(item.title, 'Header Title');
      expect(item.subtitle, isNull);
      expect(item.icon, isNull);
      expect(item.onTap, isNull);
      expect(item.switchValue, isNull);
      expect(item.checkboxValue, isNull);
    });

    test('simple constructor sets fields correctly', () {
      final item = SettingItem.simple(
        title: 'Simple Item',
        subtitle: 'Subtitle',
        onTap: () {},
      );

      expect(item.type, SettingType.simple);
      expect(item.title, 'Simple Item');
      expect(item.subtitle, 'Subtitle');
      expect(item.onTap, isNotNull);
      expect(item.icon, isNull);
      expect(item.switchValue, isNull);
      expect(item.checkboxValue, isNull);
    });

    test('withIcon constructor sets fields correctly', () {
      final item = SettingItem.withIcon(
        title: 'Icon Item',
        icon: Icons.star,
        onTap: () {},
      );

      expect(item.type, SettingType.withIcon);
      expect(item.title, 'Icon Item');
      expect(item.icon, Icons.star);
      expect(item.onTap, isNotNull);
      expect(item.subtitle, isNull);
      expect(item.switchValue, isNull);
      expect(item.checkboxValue, isNull);
    });

    test('withSwitch constructor sets fields correctly', () {
      bool switchChangedCalled = false;

      final item = SettingItem.withSwitch(
        title: 'Switch Item',
        subtitle: 'Subtitle',
        value: true,
        onChanged: (val) {
          switchChangedCalled = true;
        },
      );

      expect(item.type, SettingType.withSwitch);
      expect(item.title, 'Switch Item');
      expect(item.subtitle, 'Subtitle');
      expect(item.switchValue, true);
      expect(item.onSwitchChanged, isNotNull);

      // simulate change
      item.onSwitchChanged!(false);
      expect(switchChangedCalled, true);
    });

    test('withCheckbox constructor sets fields correctly', () {
      bool checkboxChangedCalled = false;

      final item = SettingItem.withCheckbox(
        title: 'Checkbox Item',
        value: false,
        onChanged: (val) {
          checkboxChangedCalled = true;
        },
      );

      expect(item.type, SettingType.withCheckbox);
      expect(item.title, 'Checkbox Item');
      expect(item.checkboxValue, false);
      expect(item.onCheckboxChanged, isNotNull);

      // simulate change
      item.onCheckboxChanged!(true);
      expect(checkboxChangedCalled, true);
    });
  });
}