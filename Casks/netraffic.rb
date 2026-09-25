cask "netraffic" do
  version "1.0.0"
  sha256 "12837f55e533f54aac2a68d36646ace5c8bd3d692df06eedea52f4c4dc87aa8c"

  url "https://github.com/kennethjohnbalgos/netraffic-app/archive/refs/tags/v#{version}.zip"
  name "Netraffic"
  desc "Menu bar network upload and download speed monitor"
  homepage "https://github.com/kennethjohnbalgos/netraffic-app"

  depends_on macos: :ventura

  app "netraffic-app-#{version}/Netraffic.app"

  caveats <<~EOS
    Netraffic is not notarized by Apple. If macOS blocks its first launch,
    open System Settings > Privacy & Security, scroll to Security, and click
    Open Anyway for Netraffic. Confirm with your Mac password if prompted.
  EOS
end
