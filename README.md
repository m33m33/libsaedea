# libSAEDEA

Nim Library implementing a variation of Simple And Efficient Data Encryption Algorithm

Research paper pdf: [INTERNATIONAL JOURNAL OF SCIENTIFIC & TECHNOLOGY RESEARCH VOLUME 8, ISSUE 12, DECEMBER 2019 ISSN 2277-8616](http://www.ijstr.org/final-print/dec2013/A-Survey-On-Some-Encryption-Algorithms-And-Verification-Of-Rsa-Technique.pdf)

# Usage:
`import libSAEDEA`

`gen_iv("your random data: string")`
=> gives you an Initialization Vector (type: string)


## SAEDEA complete implementation

`ecrypt("your cleartext data: string", "the shared secret: string", "initialization vector: string", "length of the cleartext data: int")`
=> gives the encrypted data (type: string)

`decrypt("the encrypted string", "the shared secret: string", "initialization vector: string", "length of the cleartext data: int")`
=> gives the cleartext data (type: string)


## SAEDEA light implementation

`ecrypt("your cleartext data: string", "the shared secret: string", "initialization vector: string")`
=> gives the encrypted data (type: string)

`decrypt("the encrypted string", "the shared secret: string", "initialization vector: string")`
=> gives the cleartext data (type: string)

## Disclamer, misc

This is implementation has not been fool proofed as per today

<small><div>Icons from <a href="https://www.flaticon.com/fr/auteurs/srip" title="srip">srip</a> from <a href="https://www.flaticon.com/fr/" title="Flaticon">www.flaticon.com</a></div></small>
