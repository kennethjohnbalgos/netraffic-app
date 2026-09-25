cask "netraffic" do
  version "1.1.0"
  sha256 "f7a1e6c34b42bff4e08a95b31aa33f1d4bb009a6db5be53171bc154358f4fbac"

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
