import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments => _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  //Post ekler
  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Belirli bir kullanıcının postlarını getirir. İlgili topluluklar listesini alır ve bu topluluklara ait postları _posts üzerinden getirir. Postları oluşturma zamanına göre azalan sırayla getirir.
  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName', whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
          .map(
            (e) => Post.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  //Misafir kullanıcının postlarını getirir. _posts üzerinden en son eklenen 10 postu getirir. Sonuç, bir Stream<List<Post>> nesnesi olarak döndürülür.
  Stream<List<Post>> fetchGuestPosts() {
    return _posts.orderBy('createdAt', descending: true).limit(10).snapshots().map(
          (event) => event.docs
          .map(
            (e) => Post.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  //Bir postu siler. İlgili postu _posts üzerinden siler. Silme işlemi başarılı ise right değerini döndürür, hata oluşursa left değeriyle bir hata nesnesi döndürür.
  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Eğer kullanıcı zaten aşağı oy vermişse, aşağı oy verdiği listeden kullanıcının ID'sini çıkarır. Kullanıcı daha önce oy vermişse, oy verdiği listeden kullanıcının ID'sini çıkarır. Kullanıcı daha önce oy vermemişse, oy verdiği listede kullanıcının ID'sini ekler.
  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  //Eğer kullanıcı zaten oy vermişse, oy verdiği listeden kullanıcının ID'sini çıkarır. Kullanıcı daha önce oy vermişse, oy verdiği listeden kullanıcının ID'sini çıkarır. Kullanıcı daha önce oy vermemişse, oy verdiği listede kullanıcının ID'sini ekler.
  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  //Bir postu id sine göre getirir.
  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  //Yorumu _comments üzerinde ekler ve yorumun ait olduğu postun commentCount alanını bir artırır.
  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //posta ait yorumları _comments üzerinden getirir. Yorumları oluşturma zamanına göre azalan sırayla getirir.
  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments.where('postId', isEqualTo: postId).orderBy('createdAt', descending: true).snapshots().map(
          (event) => event.docs
          .map(
            (e) => Comment.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

}
