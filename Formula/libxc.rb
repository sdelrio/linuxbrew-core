class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/4.3.4/libxc-4.3.4.tar.bz2"
  sha256 "0efe8b33d151de8787e33c4ba8e2161ffb9da978753f3bd12c5c0a018e7d3ef5"
  license "MPL-2.0"
  revision OS.mac? ? 1 : 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "418bb8ff673392e6d4a74a3563dac777162e3b8b99c1c780ea9c9ab642057f76"
    sha256 cellar: :any,                 big_sur:       "2aaa3faf0271abb1b3c6b6ea33c7e8c5d7a89ced2717531da71729ea2e77fd24"
    sha256 cellar: :any,                 catalina:      "77bb1192676ef031b3254e36f443b48163c2e6926afc959feaa84b4952a5b642"
    sha256 cellar: :any,                 mojave:        "069042e1d8511e2025e289cb3daec98728304df3a7521aced7103581686d74c8"
    sha256 cellar: :any,                 high_sierra:   "e84708fbaa5746ef8d25b57d34a5127501096ffacaa448b17d5b87ad4e81ae0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36ef990c391f0488ce80e6edb21fe78c3e9c6ac110ef7849a276b4b509bc0ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=gfortran -E -x c",
                          "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lm", "-lxc", "-o", "ctest",
                   *("-lm" unless OS.mac?)
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
