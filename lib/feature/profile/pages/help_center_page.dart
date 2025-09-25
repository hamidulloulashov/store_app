import 'package:flutter/material.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Help Center",
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
                    icon: Icons.support_agent_outlined,
                    title: "Customer Service",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: FontAwesomeIcons.whatsapp,
                    title: "Whatsapp",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: FontAwesomeIcons.facebook,
                    title: "Facebook",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: FontAwesomeIcons.twitter,
                    title: "Twitter",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: FontAwesomeIcons.instagram,
                    title: "Instagram",
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onTap: () {},
                  ),
                  
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
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

  

}