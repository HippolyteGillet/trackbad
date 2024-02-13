import 'package:supabase_flutter/supabase_flutter.dart';

class Connection {
  late final String supabaseUrl;
  late final String supabaseAnonKey;

  Connection(){
    setSupabaseUrl("https://betdqtexfcelqjeybept.supabase.co");
    setSupabaseAnonKey("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJldGRxdGV4ZmNlbHFqZXliZXB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIzNjg3MzMsImV4cCI6MjAxNzk0NDczM30.jMo4SMQnEU_N2sxoCAZAyWBp4eo_wb7r6HTjf0oY-W0");
  }

  Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  setSupabaseUrl(String supURL){
    this.supabaseUrl = supURL;
  }

  setSupabaseAnonKey(String supAnon){
    this.supabaseAnonKey = supAnon;
  }
}