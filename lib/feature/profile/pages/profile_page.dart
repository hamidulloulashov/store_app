import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/core/router/routes.dart' show Routes;
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = "token_storage";
  
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
  
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Account",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface, 
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileItem(
                    icon: Icons.person_outline,
                    title: "My Orders",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.account_circle_outlined,
                    title: "My Details",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
                      context.push("/update");
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.location_on_outlined,
                    title: "Address Book",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
                      context.push("/payment");
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
                        context.push('/notifactions');
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.help_outline,
                    title: "FAQs",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
                      context.push("/faqs");
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.support_agent_outlined,
                    title: "Help Center",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {
  context.push('/help');

                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface, 
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildProfileItem(
                icon: Icons.logout,
                title: "Logout",
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorNews(),
    );
  }
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.grey[700],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 9,
      thickness: 2,
      color: Colors.grey[200],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.secondary, 
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface, 
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: const Icon(
                  Icons.warning_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 20),
              
               Text(
                'Logout?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface, 
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performLogout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Yes, Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    'No, Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:Theme.of(context).colorScheme.surface, 
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();



    if (context.mounted) Navigator.pop(context);

    if (context.mounted) context.go(Routes.login);

  } catch (e) {
    print('Logout error: $e');
    if (context.mounted) Navigator.pop(context);
    if (context.mounted) context.go(Routes.login);
  }
}

}