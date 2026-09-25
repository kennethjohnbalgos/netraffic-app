cask "netraffic" do
  version "1.2.0"
  sha256 "2d279b5ce9580cad34123040d483714e679ec1f9057f270e6be1214de5de363f"

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
