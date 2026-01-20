class Siteprobe < Formula
  desc "CLI tool to fetch URLs from sitemap.xml, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "31570005571075335109a3b23a3a1995b7b535befe903c14678cda715a9e5f40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "59b8088323c7c69cbdb61f8629331b2465d5158444f6c62f7a5814211a822b5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d65ef8b3aa22f619e8b7b73c19da2e7eb7949630ca5d82740a82b9329036e8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.1/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a1fd24e7ac03cfcc12200d64cf4b2afbca676020fa6dae87afabd04bb4043bde"
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
