# Contributor: ragnarok2040 at gmail dot com

pkgname=cross-ps2-iop-gcc
pkgver=3.2.2
pkgrel=1
pkgdesc="GCC for the Playstation2 I/O Processor"
arch=('i686' 'x86_64')

license=('GPL')
url="http://www.ps2dev.org/"
makedepends=('cross-ps2-binutils>=2.14'
             'make' 'gcc34' 'patch')
options=('!strip')
source=(http://ftp.gnu.org/gnu/gcc/gcc-3.2.2/gcc-3.2.2.tar.bz2
        gcc-3.2.2-PS2.patch)


md5sums=('962a2057a2572226bc99aaeba4255e9b'
         '7e93b85c117058775f7a687349bf20c6')

_prefix=opt/ps2dev

build() {
  # Set environment variables
  unset CFLAGS CXXFLAGS

  export PATH=$PATH:/$_prefix/iop/bin

  # Patch the sources
  cd $srcdir

  msg "Patching gcc..."
  patch -p0 < gcc-3.2.2-PS2.patch || return 1

  # Build gcc with C language support  
  cd $srcdir

  msg "Building gcc for iop..."

  mkdir "iop-gcc-build" && cd "iop-gcc-build" || return 1

  CC=gcc-3.4 ../gcc-3.2.2/configure --prefix="/$_prefix/iop" --target="iop" \
      --enable-languages="c" --with-newlib --without-headers || return 1
    
  CC=gcc-3.4 make clean 
  CC=gcc-3.4 make || return 1
  CC=gcc-3.4 make -j1 DESTDIR=$pkgdir install || return 1

  msg "Removing build directory..."
  rm -rf $srcdir/iop-gcc-build || return 1

  msg "Stripping symbols from binaries..."
  cd $pkgdir/$_prefix/iop/bin

  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null

  msg "Removing older libiberty.a..."
  rm $pkgdir/$_prefix/iop/lib/libiberty.a
}
