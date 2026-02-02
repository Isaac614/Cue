import SwiftUI

extension Color {
    func getRGBA() -> (red: Double, green: Double, blue: Double, alpha: Double)? {
        #if canImport(UIKit)
        guard let components = UIColor(self).cgColor.components else { return nil }
        #elseif canImport(AppKit)
        guard let components = NSColor(self).cgColor.components else { return nil }
        #endif
        
        // Handle grayscale colors (which have 2 components: white, alpha)
        if components.count == 2 {
            return (red: Double(components[0]), green: Double(components[0]), blue: Double(components[0]), alpha: Double(components[1]))
        }
        
        // Handle RGB colors (which have 4 components: r, g, b, a)
        guard components.count >= 4 else { return nil }
        return (red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), alpha: Double(components[3]))
    }
}
