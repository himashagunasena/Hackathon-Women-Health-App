import 'package:blossom_health_app/controller/article.dart';
import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:blossom_health_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/appcolor.dart';
import '../../../utils/style.dart';

class AddArticleScreen extends StatefulWidget {
  final UserModel userModel;

  const AddArticleScreen({super.key, required this.userModel});

  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _allCategories = [
    'Disease',
    'Health Advice',
    'Beauty Tips',
    'Education',
    'Others'
  ];

  String _selectedCategory = 'Others';

  Future<void> _saveArticle() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('articles').add({
      'title': _titleController.text,
      'content': _contentController.text,
      'category': _selectedCategory,
      'created_at': Timestamp.now(),
      'authorName': widget.userModel.fullName,
      'id': widget.userModel.uid,
      'userType':widget.userModel.role
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article uploaded successfully')),
    );

    _titleController.clear();
    _contentController.clear();
    setState(() {
      _selectedCategory = 'Others';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: 'Write Your Article',
      subtitle: '',
      button: CommonButton(text: "Submit", clickCallback: _saveArticle),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              controller: _titleController,
              labelText: 'Title',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration:
                  Style().textFieldDecoration(null, null, "Content", false),
            ),
            const SizedBox(height: 16),
            const Text('Categories:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allCategories.map((category) {
                return ListButton(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Image.asset(
              Category().getImageForCategory(_selectedCategory),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ListButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.primaryColor : AppColors.enableButton,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.lightTextColor : AppColors.textColor,
        ),
      ),
    );
  }
}
