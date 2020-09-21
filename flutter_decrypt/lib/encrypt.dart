import 'package:encrypt/encrypt.dart';

//AES 256

final key = Key.fromUtf8('testkey000000000');
final iv = IV.fromUtf8('testiv0000000000');


String encrypt(String text) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(text, iv: iv);
   //print('text : $text');
   print('encrypted : ${encrypted.base64}');
  return encrypted.base64;
}

String decrypt(String text) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
  print('decrypted : ${decrypted}');
  return decrypted;
}