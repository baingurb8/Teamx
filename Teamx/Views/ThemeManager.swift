//  ThemeManager.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-10.
//

import Foundation
import SwiftUI

enum Theme: String {
    case light, dark
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "currentTheme")
        }
    }

    init() {
        if let storedTheme = UserDefaults.standard.string(forKey: "currentTheme"),
           let theme = Theme(rawValue: storedTheme) {
            currentTheme = theme
        } else {
            currentTheme = .light
        }
    }
}

struct ThemeColors {
    var backgroundColor: Color
    var textColor: Color

    static let light = ThemeColors(backgroundColor: .white, textColor: .black)
    static let dark = ThemeColors(backgroundColor: .black, textColor: .white)
}
