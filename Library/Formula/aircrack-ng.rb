class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "http://aircrack-ng.org/"

  # We can't update this due to linux-only dependencies in >1.1.
  # See https://github.com/Homebrew/homebrew/issues/29450
  url "http://download.aircrack-ng.org/aircrack-ng-1.1.tar.gz"
  sha256 "b136b549b7d2a2751c21793100075ea43b28de9af4c1969508bb95bcc92224ad"
  revision 1

  bottle do
    cellar :any
    sha256 "8d0e46c29daf895780427bfe252adef6c31faca245496fcef8f9449ce0321f34" => :el_capitan
    sha256 "11da54c7c70a4faf089e7b71669f11fb13772563bebe89dafb2210146c8c23ef" => :yosemite
    sha256 "b856ae4d438d05367b7e5c762ef90c5a06bebd39491d41edee8ba47dd517e6b5" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    # Fix incorrect OUI url
    inreplace "scripts/airodump-ng-oui-update",
      "http://standards.ieee.org/regauth/oui/oui.txt",
      "http://standards.ieee.org/develop/regauth/oui/oui.txt"

    system "make", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats; <<-EOS.undent
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
    EOS
  end
end

__END__
--- a/scripts/airodump-ng-oui-update
+++ b/scripts/airodump-ng-oui-update
@@ -7,25 +7,6 @@
 OUI_PATH="/usr/local/etc/aircrack-ng"
 AIRODUMP_NG_OUI="${OUI_PATH}/airodump-ng-oui.txt"
 OUI_IEEE="${OUI_PATH}/oui.txt"
-USERID=""
-
-
-# Make sure the user is root
-if [ x"`which id 2> /dev/null`" != "x" ]
-then
-	USERID="`id -u 2> /dev/null`"
-fi
-
-if [ x$USERID = "x" -a x$UID != "x" ]
-then
-	USERID=$UID
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-
 
 if [ ! -d "${OUI_PATH}" ]; then
 	mkdir -p ${OUI_PATH}

