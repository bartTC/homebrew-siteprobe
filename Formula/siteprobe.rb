class Siteprobe < Formula
  desc "Siteprobe is a Rust-based CLI tool that fetches all URLs from a given `sitemap.xml` url, checks their existence, and generates a performance report. It supports various features such as authentication, concurrency control, caching bypass, and more."
  homepage "https://barttc.github.io/siteprobe/"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "64c374da1a298510733ad20d8a28fd30b8a2ff1597d811cb44b8ca3e76aef0ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "3c8729a4a2ca8553da844f84be1eb573254710525b8b95753d6bac50133a87b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0ba84c4bcdf9fd3613ac3430af12fe0ad4c503bb2caec3506fbdab9dd717ac2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81610dffd7b75a3d8c5500ec6319b53e837b2c9f0b842514a78330024033ba7f"
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
