class Siteprobe < Formula
  desc "CLI tool to fetch URLs from a sitemap.xml or a plain list of URLs, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.0/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "da5d436c84f34056801233f7c1158fc65960bf9d27b55bded06cb7bdda83341a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.0/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "d6a19bb1bdc5b4595a77623e1611285400d5f4bdf6c4aba968ce3d71050e6757"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.0/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49f83bd621d51d8d3bb59649b2f683712deeabd22e427057b0fe66d941a4cbe2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.5.0/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "55d6b8b33ba4bf46da16291929fdf979ef49553b2d624b3ebe0b328034a9cb13"
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
