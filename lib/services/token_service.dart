// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

enum EnvEnum {
  pronto(
    'Pronto',
    'pronto',
    'pronto.getstream.io',
    aliases: ['stream-calls-dogfood'],
  ),
  prontoStaging(
    'Pronto Staging',
    'pronto',
    'pronto-staging.getstream.io',
  ),
  demo(
    'Demo',
    'demo',
    'pronto.getstream.io',
    aliases: [''],
  ),
  staging(
    'Staging',
    'staging',
    'pronto.getstream.io',
  );

  final String displayName;
  final String envName;
  final String hostName;
  final List<String> aliases;

  const EnvEnum(
      this.displayName,
      this.envName,
      this.hostName, {
        this.aliases = const [],
      });

  factory EnvEnum.fromSubdomain(String subdomain) {
    return EnvEnum.values.firstWhere(
          (env) => env.name == subdomain || env.aliases.contains(subdomain),
      orElse: () => EnvEnum.demo,
    );
  }

  factory EnvEnum.fromHost(String host) {
    final hostParts = host.split('.');
    final String envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return EnvEnum.fromSubdomain(envAlias);
  }
}

class TokenResponse {
  final String token;
  final String apiKey;

  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);
}

class TokenService {
  const TokenService();

  Future<TokenResponse> loadToken({
    required String userId,
    required EnvEnum environment,
    Duration? expiresIn,
  }) async {
    final queryParameters = <String, dynamic>{
      'environment': environment.envName,
      'user_id': userId,
    };

    if (expiresIn != null) {
      queryParameters['exp'] = expiresIn.inSeconds.toString();
    }

    final uri = Uri(
      scheme: 'https',
      host: environment.hostName,
      path: '/api/auth/create-token',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return TokenResponse.fromJson(body);
  }
}