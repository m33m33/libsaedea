# To run these tests, simply execute `nimble test`.

import unittest
import times
import libsaedea
import std/sha1

proc cmpStrChars(s1: string, s2: string): bool =
  if s1.len != s2.len:
    return false
  for i in 0..s1.len-1:
    if s1[i] != s2[i]:
      return false
  return true

let text = "This is a clear text message... ABCDEF 12 12 123 1234 12345 123456 $*[]@!%ù 🤖😱🎰🔮📿💈⚗️🔭🔬 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod... And the current time is:" & $getTime()
let secret = "A shared secret"
let iv = gen_iv("some random data" & $getTime())

var encrypted = saedea_encrypt(text, secret, iv, text.len)
var decrypted = saedea_decrypt(encrypted, secret, iv, text.len)

var encrypted_light = saedea_encrypt_light(text, secret, iv)
var decrypted_light = saedea_decrypt_light(encrypted_light, secret, iv)

echo "Secret:", secret
echo "IV:", iv
echo "Cleartext          :", text
echo "Decrypted          :", decrypted
echo "Decrypted_light    :", decrypted_light
#echo "Encrypted          :", encrypted
echo "Encrypted sha1     :", secureHash(encrypted)
#echo "Encrypted_light    :", encrypted_light
echo "Encrpted_light sha1:", secureHash(encrypted_light)

echo "Matching test"
check cmpStrChars(text, decrypted) == true

echo "Wrong secret test"
decrypted = saedea_decrypt(encrypted, "wrong secret", iv, text.len)
check cmpStrChars(text, decrypted) == false

echo "Wrong IV test"
decrypted = saedea_decrypt(encrypted, secret, "wrong iv", text.len)
check cmpStrChars(text, decrypted) == false

echo "Wrong length test"
decrypted = saedea_decrypt(encrypted, secret, iv, 987654)
check cmpStrChars(text, decrypted) == false

echo "All wrong test"
decrypted = saedea_decrypt(encrypted, "wrong value", "wrong value", 123456)
check cmpStrChars(text, decrypted) == false

echo "Matching test with light encryption"
check cmpStrChars(text, decrypted_light) == true

echo "Wrong secret test with light encryption"
decrypted_light = saedea_decrypt_light(encrypted_light, "wrong secret", iv)
check cmpStrChars(text, decrypted_light) == false

echo "Wrong IV test with light encryption"
decrypted_light = saedea_decrypt_light(encrypted_light, secret, "wrong iv")
check cmpStrChars(text, decrypted_light) == false

echo "All wrong test with light encryption"
decrypted_light = saedea_decrypt_light(encrypted_light, "wrong secret", "wrong iv")
check cmpStrChars(text, decrypted_light) == false
