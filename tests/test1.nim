# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils
import libSAEDEA

var text = "This is a clear text message... 12 12 123"
var secret = "shared secret"
var iv = gen_iv("true random data")
var encrypted = encrypt(text, secret, iv)
var decrypted = decrypt(encrypted, secret, iv)
echo "Secret:", secret
echo "IV:", iv
echo "Cleartext:", text
echo "Decrypted:", decrypted
echo "Encrypted:", encrypted
check count(text, decrypted, false) == 1
