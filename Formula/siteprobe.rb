class Siteprobe < Formula
  desc "CLI tool to fetch URLs from sitemap.xml, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.2/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "64234b45ae14d881681e876819c84b87b0354c0cbda92c244e8bab201bf7f7da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.2/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "a9c360bba1c16ef5dc1c5732a40170f6758c812ca50e45b32dcaab3147876cfe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.2/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7c2c73591f7ac40cce673e74ba3c6514004d30294451ef7b2884bed0885e1f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.2/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d53f27e37eab65040adcec9431433d6b13db22f499ebd6afccb77c7d5bd5a9ea"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "siteprobe" if OS.mac? && Hardware::CPU.arm?
    bin.install "siteprobe" if OS.mac? && Hardware::CPU.intel?
    bin.install "siteprobe" if OS.linux? && Hardware::CPU.arm?
    bin.install "siteprobe" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
