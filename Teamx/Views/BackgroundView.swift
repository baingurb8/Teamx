//
//  BackgroundView.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-11.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    @State private var selectedGradientIndex = 0
    let gradients: [LinearGradient]
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    init(gradients: [LinearGradient]) {
        self.gradients = gradients
    }

    var body: some View {
        gradients[selectedGradientIndex % gradients.count]
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { _ in
                withAnimation {
                    selectedGradientIndex += 1
                }
            }
    }
}
