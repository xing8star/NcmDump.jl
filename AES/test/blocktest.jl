using AES, BenchmarkTools, Test

# AES128
k=[0x54,0x68,0x61,0x74,0x73,0x20,0x6D,0x79,0x20,0x4B,0x75,0x6E,0x67,0x20,0x46,0x75]
p=[0x54,0x77,0x6F,0x20,0x4F,0x6E,0x65,0x20,0x4E,0x69,0x6E,0x65,0x20,0x54,0x77,0x6F]
c=[0x29,0xC3,0x50,0x5F,0x57,0x14,0x20,0xF6,0x40,0x22,0x99,0xB3,0x1A,0x02,0xD7,0x3A]
key = AES128Key(k)

@test c == AES.AESEncryptBlock(p, key)
@test p == AES.AESDecryptBlock(c, key)
@test p == AES.AESDecryptBlock(AES.AESEncryptBlock(p,key),key)

# Performance Checks
cache = AES.gen_cache(key)
@btime AES.AESEncryptBlock!(p, p, key, cache)
@btime AES.AESDecryptBlock!(c, c, key, cache)

# AES192
k = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17]
p = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF]
c = [0xdd, 0xa9, 0x7c, 0xa4, 0x86, 0x4c, 0xdf, 0xe0, 0x6e, 0xaf, 0x70, 0xa0, 0xec, 0x0d, 0x71, 0x91]
key = AES192Key(k)

@test c == AES.AESEncryptBlock(p, key)
@test p == AES.AESDecryptBlock(c, key)
@test p == AES.AESDecryptBlock(AES.AESEncryptBlock(p,key),key)

# Performance Checks
cache = AES.gen_cache(key)
@btime AES.AESEncryptBlock!(p, p, key, cache)
@btime AES.AESDecryptBlock!(c, c, key, cache)
