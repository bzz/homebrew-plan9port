class Plan9port < Formula
  desc "Many Plan 9 programs ported to UNIX-like operating systems"
  homepage "https://9fans.github.io/plan9port/"
  url "https://github.com/9fans/plan9port/archive/4650064a.tar.gz"
  version "20181114"
  sha256 "a19edb9d52690efa0d7bd31dd1b24bbe6abf88c49e7c5be06becc42700eeae6b"
  head "https://github.com/9fans/plan9port.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdcaa55afb6e28c4f9f1540e9e1d81d111f2ed9f85db76ca4705ad1d610e57e2" => :mojave
    sha256 "5c2efeb97b9d5a9171fc41e862223682a5b86a9af064a13381d10624bdf32d04" => :high_sierra
    sha256 "5f2d48d2f3a732795c8ab050bb705caf59a18ee86d3d89c143b22533a46bd71c" => :sierra
    sha256 "eb56faa4c63a522e34ba609fc0d4eb5af9b22715c0915629776129eb64d8625f" => :el_capitan
    sha256 "86fd2ed15a0fe79927c04a064222f88455bfc0e72bc1f97576e2962b11a70cc8" => :yosemite
    sha256 "ef0059997655128f6b41faa1023b37a071ff9976f4c94d3b3bd706be65177aa1" => :mavericks
  end

  def install
    ENV["PLAN9_TARGET"] = libexec

    system "./INSTALL"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/9"
    prefix.install Dir[libexec/"mac/*.app"]
  end

  def caveats; <<~EOS
    In order not to collide with macOS system binaries, the Plan 9 binaries have
    been installed to #{opt_libexec}/bin.
    To run the Plan 9 version of a command simply call it through the command
    "9", which has been installed into the Homebrew prefix bin.  For example,
    to run Plan 9's ls run:
        # 9 ls
  EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u.h>
      #include <libc.h>
      #include <stdio.h>

      int main(void) {
        return printf("Hello World\\n");
      }
    EOS
    system bin/"9", "9c", "test.c"
    system bin/"9", "9l", "-o", "test", "test.o"
    assert_equal "Hello World\n", shell_output("./test", 1)
  end
end

