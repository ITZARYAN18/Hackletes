import 'package:flutter/material.dart';
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
      icon: Icons.sports_soccer,
      title: 'Jump',
      isSelected: false,
    ),
    CategoryItem(
      icon: Icons.fitness_center,
      title: 'Situp',
      isSelected: false,
    ),
  ];

  // Map category titles to their corresponding button text and routes
  final Map<String, Map<String, String>> categoryActions = {
    'Running': {
      'buttonText': 'Start Running Test',
      'route': '/running-test'
    },
    'Jump': {
      'buttonText': 'Start Vertical Jump Test',
      'route': '/vertical-jump-test'
    },
    'Situp': {
      'buttonText': 'Start Situp Counter',
      'route': '/situp-counter'
    },
  };

  @override
  Widget build(BuildContext context) {
    // Get current category details
    String currentCategory = categories[selectedCategoryIndex].title;
    String buttonText = categoryActions[currentCategory]?['buttonText'] ?? 'Start Test';

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

              // Greeting message
              Center(
                child: Text(
                  'Hi Rohan, Ready to Train? 🤩',
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

              // Main action button - dynamically changes based on selected category
              MainActionButton(
                title: buttonText,
                onPressed: () => _navigateToSelectedTest(),
              ),

              Spacer(),

              // Optional: Show selected category info
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      categories[selectedCategoryIndex].icon,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Selected: ${categories[selectedCategoryIndex].title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
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

  void _navigateToSelectedTest() {
    String currentCategory = categories[selectedCategoryIndex].title;
    String? route = categoryActions[currentCategory]?['route'];

    if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      // Fallback or show a message
      _showNotImplementedDialog(currentCategory);
    }
  }

  void _showNotImplementedDialog(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Coming Soon'),
        content: Text('$category test is not implemented yet.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
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