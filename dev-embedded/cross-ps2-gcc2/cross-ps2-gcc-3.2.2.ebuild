# Contributor: ragnarok2040 at gmail dot com

pkgname=cross-ps2-ee-gcc
pkgver=3.2.2
pkgrel=1
pkgdesc="C/C++ compiler for the Playstation2 Emotion Engine"
arch=('i686' 'x86_64')
license=('GPL')
url="http://www.ps2dev.org/"
conflicts=('cross-ps2-ee-gcc-base')
makedepends=('cross-ps2-binutils>=2.14'
             'cross-ps2-ee-newlib>=1.10.0'
             'make' 'gcc34' 'patch')
options=('!strip' '!libtool')
source=(http://ftp.gnu.org/gnu/gcc/gcc-3.2.2/gcc-3.2.2.tar.bz2
        gcc-3.2.2-PS2.patch)

md5sums=('962a2057a2572226bc99aaeba4255e9b'
         '7e93b85c117058775f7a687349bf20c6')

_prefix=opt/ps2dev

build() {
  # Set environment variables
  unset CFLAGS CXXFLAGS

  export PATH=$PATH:/$_prefix/ee/bin

  # Patch the sources
  cd $srcdir

  msg "Patching gcc..."
  patch -p0 < gcc-3.2.2-PS2.patch || return 1

  # Build ee-g++
  cd $srcdir

  msg "Building gcc/g++ for ee..."

  mkdir ee-gcc-build && cd ee-gcc-build || return 1

  CC=gcc-3.4 ../gcc-3.2.2/configure --prefix="/$_prefix/ee" --target="ee" \
      --enable-languages="c,c++" --with-newlib --with-headers="/$_prefix/ee" \
      --enable-cxx-flags="-G0" || return 1

  CC=gcc-3.4 make clean 
  CC=gcc-3.4 CFLAGS_FOR_TARGET="-G0" make || return 1
  CC=gcc-3.4 make DESTDIR=$pkgdir install || return 1

  msg "Stripping symbols from binaries..."
  cd $pkgdir/$_prefix/ee/bin
  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null

  msg "Removing build directory..."
  rm -rf $srcdir/ee-gcc-build || return 1

  msg "Stripping symbols from binaries..."
  cd $pkgdir/$_prefix/ee/lib/gcc-lib/ee/3.2.2

  for _file in "cc1" "cc1plus" "collect2" "cpp0" "tradcpp0"; do
    strip --strip-unneeded $_file
  done
  
  msg "Removing older c++filt and libiberty.a..."
  rm $pkgdir/$_prefix/ee/bin/ee-c++filt
  rm $pkgdir/$_prefix/ee/lib/libiberty.a
}
