import 'dart:convert';
import 'api_client.dart';
import '../constants/api_constants.dart';
import '../../shared/models/user.dart';
import '../../features/auth/models/register_models.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'Password': password,
        }),
      );

      // The API returns 200 even for some logical errors if we look at usage, 
      // but standard HTTP might return others.
      // Based on the request, we expect a JSON body.
      final Map<String, dynamic> body = jsonDecode(response.body);
      return AuthResponse.fromJson(body);
    } catch (e) {
      // Return a failure response in case of network error or parse error
      return AuthResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  Future<RegisterResponse> registerSeller(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      return RegisterResponse.fromJson(body);
    } catch (e) {
      // Return a failure response in case of network error or parse error
      return RegisterResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logoutEndpoint}'),
         headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      // Logout error can be ignored locally, but logging it is good practice
      // ApiClient logs errors, so we might just let it be or do extra handling
    }
  }

}

