import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/utils/appcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/article_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/images.dart';
import 'comment.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  final UserModel userModel;
  final Article article;

  const ArticleDetailScreen(
      {required this.articleId,
      required this.userModel,
      required this.article});

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: article.title,
      subtitle: '',
      button: TextButton(
          onPressed: () {
            bottomSheet(context);
          },
          child: const Text(
            "comments",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          )),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .doc(articleId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final Article article = Article.fromFirestore(snapshot.data!);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(Category().getImageForCategory(article.category)),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Category().getCategoryColor(article.category),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.userType == "User"
                          ? "By ${article.authorName == "" ? "Anonymouse" : article.authorName}"
                          : "By Dr ${article.authorName == "" ? "Anonymouse" : article.authorName}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy")
                          .format(article.timestamp)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  article.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryCardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsSection(
                                      articleId: articleId,
                                      name: userModel.nickName ?? "Anonymous",
                                      articleName: article.title,
                                    )));
                      },
                      child: const Text(
                        "See More",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      )),
                ],
              ),
              FirstComments(
                articleId: articleId,
                name: userModel.nickName ?? "Anonymous",
              ),
            ],
          ),
        );
      },
    );
  }
}

class FirstComments extends StatelessWidget {
  final String articleId;
  final String name;

  const FirstComments({super.key, required this.articleId, required this.name});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final comments = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display up to 5 comments
            for (var i = 0; i < comments.length && i < 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CommentWidget(
                  commentData: comments[i],
                  articleId: articleId,
                  name: name,
                  replyShow: false,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Add a comment:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CommentInputField(
              articleId: articleId,
              name: name,
            ),
          ],
        );
      },
    );
  }
}
