import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../core/providers/firebase_providers.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

//kullanıcı profiliyle ilgili veritabanı işlemlerini gerçekleştirmek için kullanılır.
class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  //Kullanıcı profili düzenlemek için kullanılır. UserModel türünde bir kullanıcı nesnesi alır ve _users koleksiyonunda ilgili kullanıcının belgesini günceller.
  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Belirli bir kullanıcının yayınlanmış gönderilerini almak için kullanılır.
  Stream<List<Post>> getUserPosts(String uid) {
    return _posts.where('uid', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots().map(
          (event) => event.docs
          .map(
            (e) => Post.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
  //Kullanıcının itibar puanını güncellemek için kullanılır.
  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
