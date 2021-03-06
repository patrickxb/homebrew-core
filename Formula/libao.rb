class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
  sha256 "03ad231ad1f9d64b52474392d63c31197b0bc7bd416e58b1c10a329a5ed89caf"

  bottle do
    rebuild 1
    sha256 "9b64b4e9093363062dc8c939ec0d73d9c22d78776296a9f8557e7d3290b36848" => :sierra
    sha256 "159aa7704f0a3cd36bfdf659ca8ec9c399077274bff1b68aa0497fdda8b6da44" => :el_capitan
    sha256 "08d568c4bed498b2920983d9b848213779164c15489c82cc61429533337d19f5" => :yosemite
    sha256 "81b1d6c5d1920092fba0470db2840414eb99bba8ec63d6d22800e79090db8e4b" => :mavericks
    sha256 "21aa15e92c5577a4a610de8fbb3f5a72638a0c37a40c4ebebc14826359932efa" => :mountain_lion
  end

  head do
    url "https://git.xiph.org/libao.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    if build.head?
      ENV["AUTOMAKE_FLAGS"] = "--include-deps"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ao/ao.h>
      int main() {
        ao_initialize();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lao", "-o", "test"
    system "./test"
  end
end
