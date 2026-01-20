class Siteprobe < Formula
  desc "CLI tool to fetch URLs from sitemap.xml, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "caf8c3b9cfeae4b1c15a81d0831e1d4039215ac05193cd33ddd520e14c55bc02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "26850a1a19e4905c740cdb0689019a60335df6daa722539fb2e2030e2fa5de62"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95f4e5d8321159d341589a063293a8429ad2d53e1ca5328f9d9ddd7fec253dda"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b7dddc4144f18214d913007d6bfd6485fe08562eb69a3b3ee87d89a2071bb43"
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
