import 'package:dio/dio.dart';

import '../../config/supabase_config.dart';

class SupabaseRestClient {
  SupabaseRestClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: SupabaseConfig.restUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 12),
          headers: const {
            'apikey': SupabaseConfig.anonKey,
            'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
            'Content-Type': 'application/json',
          },
        ),
      );

  final Dio dio;
}
