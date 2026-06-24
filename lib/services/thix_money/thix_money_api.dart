import 'package:supabase_flutter/supabase_flutter.dart';

class ThixMoneyApi {
  final SupabaseClient _client;

  ThixMoneyApi({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<Map<String, dynamic>> invoke(String fn, {Map<String, dynamic>? body}) async {
    final response = await _client.functions.invoke(fn, body: body ?? <String, dynamic>{});
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{'data': data};
  }
}
