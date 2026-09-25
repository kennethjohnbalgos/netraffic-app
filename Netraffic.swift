import AppKit
import SystemConfiguration

private struct Counters {
    let received: UInt64
    let sent: UInt64
}

private func primaryInterface() -> String? {
    guard let store = SCDynamicStoreCreate(nil, "Netraffic" as CFString, nil, nil),
          let value = SCDynamicStoreCopyValue(store, "State:/Network/Global/IPv4" as CFString) as? [String: Any] else { return nil }
    return value["PrimaryInterface"] as? String
}

private func counters(for name: String) -> Counters? {
    var head: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&head) == 0, let first = head else { return nil }
    defer { freeifaddrs(head) }
    var cursor: UnsafeMutablePointer<ifaddrs>? = first
    while let node = cursor {
        let item = node.pointee
        if String(cString: item.ifa_name) == name,
           let address = item.ifa_addr,
           address.pointee.sa_family == UInt8(AF_LINK),
           let data = item.ifa_data?.assumingMemoryBound(to: if_data.self) {
            return Counters(received: UInt64(data.pointee.ifi_ibytes), sent: UInt64(data.pointee.ifi_obytes))
        }
        cursor = item.ifa_next
    }
    return nil
}

private func speed(_ bytesPerSecond: Double) -> String {
    let units = ["B", "K", "M", "G"]
    var value = max(0, bytesPerSecond)
    var unit = 0
    while value >= 1000 && unit < units.count - 1 { value /= 1000; unit += 1 }
    let number = value < 10 && unit > 0 ? String(format: "%.1f", value) : String(format: "%.0f", value)
    return "\(number)\(units[unit])"
}

final class NetrafficApp: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let uploadLabel = NSTextField(labelWithString: "↑ —")
    private let downloadLabel = NSTextField(labelWithString: "↓ —")
    private var timer: Timer?
    private var previous: Counters?
    private var previousTime: TimeInterval = 0
    private var interfaceName: String?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: 44)
        if let button = statusItem.button {
            button.title = ""
            button.toolTip = "Current network upload and download speed"

            let labels = NSStackView(views: [uploadLabel, downloadLabel])
            labels.orientation = .vertical
            labels.alignment = .leading
            labels.spacing = -2
            labels.translatesAutoresizingMaskIntoConstraints = false
            for label in [uploadLabel, downloadLabel] {
                label.font = .monospacedDigitSystemFont(ofSize: 9, weight: .medium)
                label.textColor = .labelColor
                label.lineBreakMode = .byClipping
                label.translatesAutoresizingMaskIntoConstraints = false
                label.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }
            button.addSubview(labels)
            NSLayoutConstraint.activate([
                labels.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 2),
                labels.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Netraffic", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.tolerance = 0.1
        update()
    }

    @objc private func update() {
        let name = primaryInterface()
        guard let name, let current = counters(for: name) else {
            interfaceName = nil
            previous = nil
            uploadLabel.stringValue = "↑ —"
            downloadLabel.stringValue = "↓ —"
            return
        }

        let now = ProcessInfo.processInfo.systemUptime
        if interfaceName == name, let previous, now > previousTime,
           current.received >= previous.received, current.sent >= previous.sent {
            let interval = now - previousTime
            let down = speed(Double(current.received - previous.received) / interval)
            let up = speed(Double(current.sent - previous.sent) / interval)
            uploadLabel.stringValue = "↑ \(up)"
            downloadLabel.stringValue = "↓ \(down)"
        } else {
            uploadLabel.stringValue = "↑ —"
            downloadLabel.stringValue = "↓ —"
        }
        interfaceName = name
        previous = current
        previousTime = now
    }

    @objc private func quit() { NSApplication.shared.terminate(nil) }
}

let app = NSApplication.shared
let delegate = NetrafficApp()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
