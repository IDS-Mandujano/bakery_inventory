class SupabaseConfig {
  static const String url = 'https://tovnyksgpzxaugzuaswr.supabase.co';
  static const String anonKey = 'sb_publishable_Hm18V9NqZ6SPc63LO-b4UQ_L_0T9jBn';
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
  };
}