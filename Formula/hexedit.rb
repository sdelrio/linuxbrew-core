class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.5.tar.gz"
  sha256 "27a2349f659e995d7731ad672450f61a2e950330049a6fb59b77490c5e0015ac"
  license "GPL-2.0-or-later"
  head "https://github.com/pixel/hexedit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7110e508b3df9cc7b2db354003b96cfed9d8a1fe1449b7df3dd9fde7fb6629" => :big_sur
    sha256 "b292c19f7f562a6d062f834395f4add815855ae4c9bfb9192a967af7c135da06" => :catalina
    sha256 "17eb067bc169a802ebdfe9a4af927cb70f2b2230337a78ee4ef00dc5cef1c7ba" => :mojave
    sha256 "cd9b838e99eafc11ab15415f46073e549273b6f461e37adb9e6eaead2e93021d" => :high_sierra
    sha256 "c81ec2d9c26d0e0c26b97d8560f27a737971c0cfed1e5ea0162d372b08eacf40" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
