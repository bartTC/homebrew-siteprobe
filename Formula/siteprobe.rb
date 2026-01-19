class Siteprobe < Formula
  desc "CLI tool to fetch URLs from sitemap.xml, check their existence, and generate performance reports"
  homepage "https://barttc.github.io/siteprobe/"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-aarch64-apple-darwin.tar.xz"
      sha256 "24fb972a08779cca278b674bec2e7ac633a86a07ee6b09314ee431f9185a7e6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-x86_64-apple-darwin.tar.xz"
      sha256 "8f9edc6d565fad1431deda6a7d6ce6092d167c4f8fe0522a57e4ee2671a058d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "575277f27f7fe232cae581543d2afe1182caf81c01b0f62044c79da85a39c981"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bartTC/siteprobe/releases/download/v1.2.0/siteprobe-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c621f8b4bf7173ce5cbbd3396f7f54897232c07f5ff235bf92204042634686ce"
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
