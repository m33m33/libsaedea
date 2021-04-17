import random
import oids


#
# gen_iv(random_data): string
#
# Generate random data as for the initialization vector
# Will be stronger when provided "true" random_data
#
proc gen_iv*(random_data: string): string =
  var iv = $genoid() & random_data # make up some random str
  var randomizer = initRand(hash(genOid()))
  randomizer.shuffle(iv)
  for c in 0..iv.len-1:
    iv[c] = chr(cast[uint16](iv[c]) + (cast[uint16](iv[0]) mod 5))
  return iv
#endproc


#
# encrypt_stage1(secret, iv, length): string
#
# First pass of string encryption, xor the secret key and initialization vector
# it needs the original cleartext message legth
#
proc encrypt_stage1(secret: string, iv: string, len: int): string =
  var hidden_str: string
  var i = 0

  # xor on repeated secret text and iv up to cleartext length
  while i < len:
    hidden_str.add(cast[char](
                    cast[int32](
                      secret[i mod secret.len]) xor
                    cast[int32](
                      iv[(i mod iv.len)])))
    i+=1
  return hidden_str
#endproc


#
# encrypt_stage1(secret, iv): string
#
# First pass of string encryption, xor the secret key and initialization vector
#
proc encrypt_light_stage1(secret: string, iv: string): string =
  var hidden_str: string
  var i = 0

  # xor on repeated secret text and iv up to cleartext length
  while i < secret.len:
    hidden_str.add(cast[char](
                    cast[int32](
                      secret[i]) xor
                    cast[int32](
                      iv[(i mod iv.len)])))
    i+=1
  return hidden_str
#endproc


#
# decrypt_stage1(secret, iv, length): string
#
# First pass of string decryption, xor secret,initialization vector, then cypertext and the product
# it needs the original cleartext message length
#
proc decrypt_stage1(hidden: string, iv: string, len: int): string =
  var product: string
  var i = 0

  # xor on repeated ciphertext and iv up to cleartext length
  while i < len:
    product.add(cast[char](
                  cast[int32](
                    hidden[i mod hidden.len]) xor
                  cast[int32](
                    iv[(i mod iv.len)])))
    i+=1
  return product
#endproc


#
# decrypt_stage1(secret, iv): string
#
# First pass of string decryption, xor secret,initialization vector, then cypertext and the product
#
proc decrypt_light_stage1(hidden: string, iv: string): string =
  var product: string
  var i = 0

  # xor on repeated ciphertext and iv up to cleartext length
  while i < hidden.len:
    product.add(cast[char](
                  cast[int32](
                    hidden[i]) xor
                  cast[int32](
                    iv[(i mod iv.len)])))
    i+=1
  return product
#endproc


#
# encrypt(text, secret, initialization vector, text length): string
#
# Simple encryption for text, using secret and a random initialization vector
# The lenght of cleartext message is needed, this will produce an encrypted message
# following the SAEDEA paper
#
proc saedea_encrypt*(text: string, secret: string, iv: string, len: int): string =
  let intermediate = encrypt_stage1(secret, iv, len)
  return encrypt_stage1(text, intermediate, len)
#endproc


#
# encrypt_light(text, secret, initialization vector): string
#
# Light version
# Simple encryption for text, using secret and a random initialization vector
#
proc saedea_encrypt_light*(text: string, secret: string, iv: string): string =
  let intermediate = encrypt_light_stage1(secret, iv)
  return encrypt_light_stage1(text, intermediate)
#endproc

#
# decrypt(hidden, secret, initialization vector, lenght of the cleartext message): string
#
# Simple decryption for ciphertext, using secret and a random initialization vector
# The original cleartext lenght is needed
#
proc saedea_decrypt*(hidden_str: string, secret: string, iv: string, len: int): string =
  let intermediate = decrypt_stage1(secret, iv, len)
  return decrypt_stage1(hidden_str, intermediate, len)
#endproc

#
# decrypt_light(hidden, secret, initialization vector): string
#
# Light version
# Simple decryption for ciphertext, using secret and a random initialization vector
#
proc saedea_decrypt_light*(hidden_str: string, secret: string, iv: string): string =
  let intermediate = decrypt_light_stage1(secret, iv)
  return decrypt_light_stage1(hidden_str, intermediate)
#endproc
