class Siteprobe < Formula
  desc "CLI tool to fetch URLs from sitemap.xml, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.4.0/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "5940c80ff436ccb3937b1d110c94a7bae22353ccb98ed438d3276e52e66a34bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.4.0/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "406516ad1a451046828e88c94b4ee0057a712c7b0eefa07b1fb4dceb1e858db8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.4.0/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2638998cd5d1b1ea53eda8361f3d700e6d3747e9eb2a3ea260e09949ecb63bd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.4.0/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0533aba141db56c62ed1aa6fbbbde7221211fd7f803e02f74bfed4c646861ed9"
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
