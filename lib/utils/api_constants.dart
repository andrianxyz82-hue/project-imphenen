class ApiConstants {
  // IMPORTANT: Never commit real API keys to Git!
  // Set these as environment variables in Codemagic:
  // - GEMINI_API_KEY
  // - HUGGINGFACE_TOKEN
  
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String huggingFaceToken = String.fromEnvironment('HUGGINGFACE_TOKEN', defaultValue: '');
}
