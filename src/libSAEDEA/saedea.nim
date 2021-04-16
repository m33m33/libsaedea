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
# decrypt_stage1(secret, iv): string
#
# First pass of string decryption, xor secret,initialization vector, then cypertext and the product
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
# encrypt(text, secret, initialization vector, text length): string
#
# Simple encryption for text, using secret and a random initialization vector
# The lenght of cleartext message is needed, this will produce an encrypted message
# following the SAEDEA paper
#
proc encrypt*(text: string, secret: string, iv: string, len: int): string =
  let intermediate = encrypt_stage1(secret, iv, len)
  #return encode(encrypt_stage1(text, intermediate, text.len))
  return encrypt_stage1(text, intermediate, len)
#endproc


#
# encrypt(text, secret, initialization vector): string
#
# Light version
# Simple encryption for text, using secret and a random initialization vector
#
proc encrypt*(text: string, secret: string, iv: string): string =
  let intermediate = encrypt_stage1(secret, iv, text.len)
  #return encode(encrypt_stage1(text, intermediate, text.len))
  return encrypt_stage1(text, intermediate, intermediate.len)
#endproc

#
# decrypt(hidden, secret, initialization vector, lenght of the cleartext message): string
#
# Simple decryption for ciphertext, using secret and a random initialization vector
# The original cleartext lenght is needed
#
proc decrypt*(hidden_str: string, secret: string, iv: string, len: int): string =
  let intermediate = decrypt_stage1(secret, iv, len)
  #return decrypt_stage1(decode(hidden_str), intermediate, len)
  return decrypt_stage1(hidden_str, intermediate, len)
#endproc

#
# decrypt(hidden, secret, initialization vector): string
#
# Light version
# Simple decryption for ciphertext, using secret and a random initialization vector
#
proc decrypt*(hidden_str: string, secret: string, iv: string): string =
  let intermediate = decrypt_stage1(secret, iv, hidden_str.len)
  #return decrypt_stage1(decode(hidden_str), intermediate, len)
  return decrypt_stage1(hidden_str, intermediate, intermediate.len)
#endproc
