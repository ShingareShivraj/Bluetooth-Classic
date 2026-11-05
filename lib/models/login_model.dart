class LoginModel {
  final String site;
  final String user;
  final String apiKey;
  final String apiSecret;

  const LoginModel({
    required this.site,
    required this.user,
    required this.apiKey,
    required this.apiSecret,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      site: json['site']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      apiKey: json['api_key']?.toString() ?? '',
      apiSecret: json['api_secret']?.toString() ?? '',
    );
  }

  bool get isValid =>
      site.isNotEmpty &&
          user.isNotEmpty &&
          user != 'Guest' &&
          apiKey.isNotEmpty &&
          apiSecret.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'site': site,
    'user': user,
    'api_key': apiKey,
    'api_secret': apiSecret,
  };
}