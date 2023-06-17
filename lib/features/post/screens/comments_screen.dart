import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../../features/auth/controlller/auth_controller.dart';
import '../../../features/post/controller/post_controller.dart';
import '../../../features/post/widgets/comment_card.dart';
import '../../../models/post_model.dart';
import '../../../responsive/responsive.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  //State sınıfı sonlandığında çağrılır ve kullanılan controller'ı temizlemek için kullanılır.
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  //yorum ekler.
  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
      context: context,
      text: commentController.text.trim(),
      post: post,
    );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              if (!isGuest)
                Responsive(
                  child: TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Neler düşünüyorsun?',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ref.watch(getPostCommentsProvider(widget.postId)).when(
                data: (data) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = data[index];
                        return CommentCard(comment: comment);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(
                    error: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
            ],
          );
        },
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
