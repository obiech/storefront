import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

typedef RepoResult<T> = Future<Either<Failure, T>>;
