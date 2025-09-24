pkgname=dtbloader
pkgver=1.5.1
pkgrel=2
pkgdesc="EFI driver that finds and installs DeviceTree into the UEFI configuration table"
url="https://github.com/TravMurav/dtbloader"
arch=('x86_64' 'aarch64')
license=("BSD-3-Clause")
makedepends=('zig')
options=('!strip')
source=(
  "https://github.com/TravMurav/dtbloader/releases/download/1.5.1/dtbloader-1.5.1.tar.gz"
  "https://github.com/ncroxon/gnu-efi/archive/refs/tags/3.0.19.tar.gz"
  "https://github.com/clibs/sha1/archive/refs/tags/0.1.0.tar.gz"
  "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-1.7.2.tar.gz"
  "main.zig"
  "build.zig"
  "build.zig.zon"
  "dtbloader.hook"
  "install-dtbloader.sh"
)

sha256sums=(
  'cf80e053023b1cef03f5e1b182f3e31c40be2b999dd1e82aa0354a5404bd8c89'
  'e2ae35d4bdab887aeb4fd2ee721aa8c3d39bbc50518c83800affa49b98dd9ce8'
  'ae7c9fe2244e3e92b7d534f18123ac89be9a8af3842e299483a5dc912f759be8'
  '8f1486962f093f28a2f79f01c1fd82f144ef640ceabe555536d43362212ceb7c'
  'e6a73f09a28200c6faee430a3c46977b4b99beb7d1aa5e4a6e90458c22502b64'
  '5f866434fb099f23ee56ad63d4740a18cc2f37f867d6506676df07102dfdbe86'
  'SKIP'
  'b150cd02467f3289bf3b9c5bb04ade260f5a2ea76347c3d9647990f395132c80'
  '8e02eafabcf2b7317e44bf85d806d172aa5b1b5ca8e1aa4a0c815502732aa804'
)

export ZIG_LOCAL_CACHE_DIR=$BUILDDIR/.zig-cache
export CARCH=aarch64

prepare() {
  zig fetch --save=dtbloader dtbloader-1.5.1
  zig fetch --save=gnu-efi gnu-efi-3.0.19
  zig fetch --save=dtc dtc-1.7.2
  zig fetch --save=sha1 sha1-0.1.0
}

build() {
  zig build -Doptimize=ReleaseSmall
}

package() {
  zig build -Doptimize=ReleaseSmall -p "${pkgdir}"/usr/share/dtbloader
  install -Dm644 "${srcdir}/dtbloader.hook" "${pkgdir}/usr/share/libalpm/hooks/96-dtbloader.hook"
  install -Dm755 "${srcdir}/install-dtbloader.sh" "${pkgdir}/usr/bin/install-dtbloader"
}

# vim:set ts=8 sts=2 sw=2 et:
