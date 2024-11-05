import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';
import '../../widget/common_textfield.dart';

class CommentsSection extends StatelessWidget {
  final String articleId;
  final String name;
  final String? articleName;

  const CommentsSection({required this.articleId, required this.name, this.articleName});

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: "Comments",
      subtitle: "Comments of ${articleName}",
      button: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [  const Text(
        'Add a comment:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
        CommentInputField(
          articleId: articleId,
          name: name,
        ),],),
      child: StreamBuilder<QuerySnapshot>(
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
              for (var comment in comments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: CommentWidget(
                    commentData: comment,
                    articleId: articleId,
                    name: name,
                  ),
                ),
              const SizedBox(height: 16),

            ],
          );
        },
      ),
    );
  }
}

class CommentInputField extends StatefulWidget {
  final String articleId;
  final String name;

  const CommentInputField(
      {super.key, required this.articleId, required this.name});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _controller = TextEditingController();

  void _submitComment() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.articleId)
          .collection('comments')
          .add({
        'content': _controller.text,
        'senderName': widget.name,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: _controller,
      labelText: '',
      hint: "Write your comment",
      iconButton: IconButton(
        icon: const Icon(Icons.send),
        onPressed: _submitComment,
        color: AppColors.primaryColor,
      ),
    );
  }
}

class ReplyInputField extends StatefulWidget {
  final String articleId;
  final String name;
  final String commentId;

  const ReplyInputField(
      {required this.articleId, required this.commentId, required this.name});

  @override
  _ReplyInputFieldState createState() => _ReplyInputFieldState();
}

class _ReplyInputFieldState extends State<ReplyInputField> {
  final TextEditingController _replyController = TextEditingController();

  void _submitReply() {
    if (_replyController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.articleId)
          .collection('comments')
          .doc(widget.commentId)
          .collection('replies')
          .add({
        'content': _replyController.text,
        'senderName': widget.name,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _replyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: _replyController,
      labelText: '',
      hint: "Reply",
      iconButton: IconButton(
        icon: const Icon(Icons.send),
        onPressed: _submitReply,
        color: AppColors.primaryColor,
      ),
    );
    ;
  }
}

class CommentWidget extends StatefulWidget {
  final DocumentSnapshot commentData;
  final String articleId;
  final String name;
  final bool replyShow;

  const CommentWidget({
    super.key,
    required this.commentData,
    required this.articleId,
    required this.name,
    this.replyShow = true,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool reply = false;

  @override
  Widget build(BuildContext context) {
    final commentMap = widget.commentData.data() as Map<String, dynamic>;
    final String commentContent = commentMap['content'] ?? "";
    final String senderName = commentMap['senderName'] ?? "Anonymous";
    return commentContent == ""
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$senderName: $commentContent',
                style: const TextStyle(fontSize: 16),
              ),
              widget.replyShow
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          reply = !reply;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Reply",
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 14),
                      ))
                  : const SizedBox.shrink(),
              widget.replyShow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        RepliesSection(
                            articleId: widget.articleId,
                            commentId: widget.commentData.id),
                        const SizedBox(height: 8),
                        Visibility(
                            visible: reply,
                            child: ReplyInputField(
                              articleId: widget.articleId,
                              commentId: widget.commentData.id,
                              name: widget.name,
                            )),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          );
  }
}

class RepliesSection extends StatelessWidget {
  final String articleId;
  final String commentId;

  const RepliesSection({required this.articleId, required this.commentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final replies = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var reply in replies)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ReplyWidget(replyData: reply),
              ),
          ],
        );
      },
    );
  }
}

class ReplyWidget extends StatelessWidget {
  final DocumentSnapshot replyData;

  const ReplyWidget({required this.replyData});

  @override
  Widget build(BuildContext context) {
    final replyMap = replyData.data() as Map<String, dynamic>;
    final String replyContent = replyMap['content'] ?? "";
    final String senderName = replyMap['senderName'] ?? "Anonymous";

    return replyContent == ""
        ? SizedBox.shrink()
        : Text(
            '$senderName: $replyContent',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          );
  }
}
