import 'package:cipher2/cipher2.dart';

//AES 128

//Para o Cipher2 funcionar é importante que no build.gradle esteja extamente esta versão 'com.android.tools.build:gradle:3.2.1'
//it is important that in build.gradle there is exactly this version 'com.android.tools.build:gradle:3.2.1' for Cipher2 to work

final String key = 'testkey000000000';
final String iv = 'testiv0000000000';

Future<String> encryptCipher2(String plainText) async {
  String encrypt = await Cipher2.encryptAesCbc128Padding7(plainText, key, iv);
  print(encrypt);
  return encrypt;
}

Future<String> decryptCipher2(Future<String> encryptedString) async {
  String decrypt = await Cipher2.decryptAesCbc128Padding7(await encryptedString, key, iv);
  print(decrypt);
  return decrypt;
}
