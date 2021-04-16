import random
import oids
import base64

#
# gen_iv(random_data): string
#
# Generate random data as for the initialization vector
# Will be stronger when provided "true" random_data
#
proc gen_iv*(random_data: string): string =
  var iv = encode($genoid() & random_data)
  var randomizer = initRand(hash(genOid()))
  randomizer.shuffle(iv)
  return iv
#endproc


#
# encrypt_stage1(secret, iv): string
#
# First pass of string encryption, xor the secret key and initialization vector
#
proc encrypt_stage1*(secret: string, iv: string): string =
  var hidden_str: string
  var i = 0
  while i < secret.len:
    hidden_str.add(cast[char](cast[int32](secret[i]) xor cast[int32](iv[(i mod iv.len)])))
    i+=1
  return hidden_str
#endproc


#
# decrypt_stage1(secret, iv): string
#
# First pass of string decryption, xor secret,initialization vector, then cypertext and the product
#
proc decrypt_stage1*(hidden: string, iv: string): string =
  var product: string
  var i = 0
  while i < hidden.len:
    product.add(cast[char](cast[int32](hidden[i]) xor cast[int32](iv[(i mod iv.len)])))
    i+=1
  return product
#endproc


#
# encrypt(text, secret, initialization vector): string
#
# Simple encryption for text, using secret and a random initialization vector
#
proc encrypt*(text: string, secret: string, iv: string): string =
  return encode(encrypt_stage1(text, encrypt_stage1(secret, iv)))
#endproc


#
# decrypt(hidden, secret, initialization vector): string
#
# Simple decryption for ciphertext, using secret and a random initialization vector
#
proc decrypt*(hidden_str: string, secret: string, iv: string): string =
  return decrypt_stage1(decode(hidden_str), decrypt_stage1(secret, iv))
#endproc
