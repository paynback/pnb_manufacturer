import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/screen/add_product_offer_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/offers_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      SettingItemData(
        icon: Icons.discount,
        title: "Add Offer",
        subtitle: "Add offer for your products",
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddProductOfferScreen();
          },));
        },
      ),     
      SettingItemData(
        icon: Icons.discount,
        title: "Offers",
        subtitle: "Your product offers",
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return OffersScreen();
          },));
        },
      ),     
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: settings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = settings[index];
          return SettingItem(item: item);
        },
      ),
    );
  }
}

class SettingItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  SettingItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });
}

class SettingItem extends StatelessWidget {
  final SettingItemData item;
  const SettingItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: pnbwhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 28, color: item.iconColor ?? Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: item.titleColor ?? Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}