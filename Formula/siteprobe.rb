class Siteprobe < Formula
  desc "CLI tool to fetch URLs from a sitemap.xml or a plain list of URLs, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.1/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "72277b8d79dc337afcc934c130408034ae3cf855e4eaa8757bfe32aa9b2a0359"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.1/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "1954433fd50cb36588f5ab484e8fe36294b842e23a1a471fce12b4f42f27a105"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.1/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8490f611d3b1876588eb3f50771efabc54a7bd471075becbd84df84b65c9e202"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.1/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4736be404321e81b7a713266d56c3ec1a6c121fb6cadc884059efeced19b4ce6"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "siteprobe"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "siteprobe"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "siteprobe"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "siteprobe"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
