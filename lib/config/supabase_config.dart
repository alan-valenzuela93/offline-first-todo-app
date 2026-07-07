class SupabaseConfig {
  static const String projectId = String.fromEnvironment('PROJECT_ID');
  static const String anonKey = String.fromEnvironment('ANON_KEY');
  static const String projectUrl = 'https://$projectId.supabase.co';
  static const String restUrl = '$projectUrl/rest/v1';

  static bool get isConfigured =>
      projectId.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
