import 'package:fpdart/fpdart.dart';
import 'package:parrot_project/core/failure.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;