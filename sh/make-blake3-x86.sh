#!/bin/sh

# note that the C impl is not multithreaded.

# in blake3/c/
gcc -shared -O3 -o libblake3.so blake3.c blake3_dispatch.c blake3_portable.c \
    blake3_sse2_x86-64_unix.S blake3_sse41_x86-64_unix.S blake3_avx2_x86-64_unix.S \
    blake3_avx512_x86-64_unix.S
### Intrinsics-based
# gcc -c -fPIC -O3 -msse2 blake3_sse2.c -o blake3_sse2.o
# gcc -c -fPIC -O3 -msse4.1 blake3_sse41.c -o blake3_sse41.o
# gcc -c -fPIC -O3 -mavx2 blake3_avx2.c -o blake3_avx2.o
# gcc -c -fPIC -O3 -mavx512f -mavx512vl blake3_avx512.c -o blake3_avx512.o
# gcc -shared -O3 -o libblake3.so blake3.c blake3_dispatch.c blake3_portable.c \
#     blake3_avx2.o blake3_avx512.o blake3_sse41.o blake3_sse2.o
