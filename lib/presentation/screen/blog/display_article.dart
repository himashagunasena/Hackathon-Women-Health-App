import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/article_model.dart';
import '../../../utils/appcolor.dart';
import '../../../utils/images.dart';
import 'add_article.dart';
import 'article_details.dart';

class ArticleListScreen extends StatefulWidget {
  final UserModel userModel;

  const ArticleListScreen({super.key, required this.userModel});

  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  String searchQuery = '';
  bool showMyArticles = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: 'Blog',
      subtitle: '',
      icon: IconButton(
        icon: Container(
          height: 28,
          width: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
          ),
          child: const Icon(Icons.add),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddArticleScreen(
                userModel: widget.userModel,
              ),
            ),
          );
        },
        color: AppColors.lightTextColor,
      ),
      child: Column(
        children: [
          CommonTextField(
            labelText: '',
            hint: "Search",
            onChange: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            controller: searchController,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              ListButton(
                label: 'All Articles',
                isSelected: !showMyArticles,
                onTap: () {
                  setState(() {
                    showMyArticles = false;
                  });
                },
              ),
              ListButton(
                isSelected: showMyArticles,
                onTap: () {
                  setState(() {
                    showMyArticles = true;
                  });
                },
                label: 'My Articles',
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('articles').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
              }

              final articles = snapshot.data!.docs.map((doc) {
                return Article.fromFirestore(doc);
              }).toList();

              final filteredArticles = articles.where((article) {
                final matchesSearch = article.title
                    .toLowerCase()
                    .contains(searchQuery) ||
                    article.authorName.toLowerCase().contains(searchQuery) ||
                    article.category.toLowerCase().contains(searchQuery);
                final isMyArticle =
                    article.authorName == widget.userModel.fullName;

                return matchesSearch && (showMyArticles ? isMyArticle : true);
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(
                              articleId: article.id,
                              userModel: widget.userModel,
                              article: article,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: article.imageUrl.isEmpty
                                    ? AssetImage(Category().getImageForCategory(article.category)) as ImageProvider
                                    : NetworkImage(article.imageUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  AppColors.textColor.withOpacity(0.5),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'By ${article.authorName}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article.timestamp.toLocal().toString().substring(0, 10),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
