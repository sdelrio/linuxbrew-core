class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.3.0/qpdf-10.3.0.tar.gz"
  sha256 "4649c66ddb3a4fc4b18927667fd3ae20a9edfbbdc1017ee1ed1e548d3abe00d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3294e47095527d787403863169b92b16ff2fd8e5ac4355ce5545a096afc19f08"
    sha256 cellar: :any,                 big_sur:       "e32189770a71e953260a3a0785a8f20bf154ab80c43cd6cea24e6b4ae78c73c1"
    sha256 cellar: :any,                 catalina:      "b54493c6cc63be6f7208981cb7af6796e3e3399c524964c741469f21a88c7871"
    sha256 cellar: :any,                 mojave:        "a67999a7c8434e009324fe7f341cce059b1f9c7983090c29068c81083c036c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e43df19fc970d0114193a9c67d3ef8d3707e7d57f5deeaa8017e78a4a808b10"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
