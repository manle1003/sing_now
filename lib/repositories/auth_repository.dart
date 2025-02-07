import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  final ApiServices apiClient;

  AuthRepository({required this.apiClient});

}
