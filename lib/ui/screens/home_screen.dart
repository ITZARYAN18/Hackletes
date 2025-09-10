import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth_services.dart';
import '../widgets/app_header.dart';
import '../widgets/category_card.dart';
import '../widgets/main_action_button.dart';
import '../../models/category_item.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  final List<CategoryItem> categories = [
    CategoryItem(
      icon: Icons.directions_run,
      title: 'Running',
      isSelected: true,
    ),
    CategoryItem(
      icon:FontAwesomeIcons.personDrowning,
      title: 'Jumps',
      isSelected: false,
    ),
    CategoryItem(
      icon: Icons.fitness_center,
      title: 'Situp',
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userName = AuthService.currentUser ?? 'User';
    final selectedCategory = categories[selectedCategoryIndex].title;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and download button
              AppHeader(
                onDownloadPressed: () => _showDownloadDialog(),
              ),

              SizedBox(height: 40),

              // Personalized greeting message
              Center(
                child: Text(
                  'Hi $userName, Ready to Train? 🤩',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Category selection cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  CategoryItem category = entry.value;

                  return CategoryCard(
                    category: category,
                    isSelected: selectedCategoryIndex == index,
                    onTap: () => _onCategoryTap(index),
                  );
                }).toList(),
              ),

              SizedBox(height: 40),

              // Dynamic main action button based on selected category
              MainActionButton(
                title: 'Start ${selectedCategory == 'Situp' ? 'Situp' : selectedCategory} Test',
                onPressed: () => _navigateToTest(selectedCategory),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(int index) {
    setState(() {
      selectedCategoryIndex = index;
      for (int i = 0; i < categories.length; i++) {
        categories[i].isSelected = i == index;
      }
    });
  }

  void _navigateToTest(String category) {
    // Navigate based on selected category
    if (category == 'Running') {
      // Navigate to running test
      Navigator.pushNamed(context, '/vertical-jump-test'); // placeholder
    } else if (category == 'Soccer') {
      // Navigate to soccer test
      Navigator.pushNamed(context, '/vertical-jump-test'); // placeholder
    } else if (category == 'Situp') {
      Navigator.pushNamed(context, '/vertical-jump-test'); // Will be situp test
    }
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Download Progress'),
        content: Text('Export your training data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement download functionality
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }
}