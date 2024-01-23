class Token {
  String accessToken;
  String tokenType;
  int expiresIn;

  Token(this.accessToken, this.tokenType, this.expiresIn);

  factory Token.fromJSON(Map<String, dynamic> parsedJson) {
    return Token(
      parsedJson['access_token'],
      parsedJson['token_type'],
      parsedJson['expires_in'],
    );
  }
}