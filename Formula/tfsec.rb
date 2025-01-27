class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.6.tar.gz"
  sha256 "c8e56f367b9978914693db7ca4dec684af2e87660191fde628486322b11b4c3a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10ff5a738bc854a2afefdeb237d3454dbcb1926678dfcdc0a20a0bbfffb2258a"
    sha256 cellar: :any_skip_relocation, big_sur:       "60f7b72fc31c2b3ff284fef3a6780e4a0d230bf259c41402c5385215bf5bd582"
    sha256 cellar: :any_skip_relocation, catalina:      "1787a26a4a8d632cfa3c5c9b4ebcd7becc3ef629a8feff58169a326f3465f072"
    sha256 cellar: :any_skip_relocation, mojave:        "f9a23aa6d12487110c4dd7729aacde806656ce10e3a7b9914c5a5c6163cd5500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2625e92fd92d37611be3e6c55a737910e7712868543a411b33fd3d56f24b2d"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    assert_no_match(/WARNING/, good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
