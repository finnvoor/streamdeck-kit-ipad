//
//  StreamDeckSimulator.PreviewView.swift
//
//  Created by Roman Schlagowsky on 03.01.24.
//

import Combine
import StreamDeckKit
import SwiftUI

public extension StreamDeckSimulator {

    struct PreviewView<SDView: StreamDeckView>: View {
        private let product: StreamDeckProduct
        private let configuration: StreamDeckSimulator.Configuration
        private let showOptions: Bool
        private let streamDeckView: () -> SDView

        @State private var showDeviceBezels: Bool
        @State private var showKeyAreaBorders: Bool

        public init(
            streamDeck product: StreamDeckProduct = .regular,
            serialNumber: String? = nil,
            showOptions: Bool = true,
            showDeviceBezels: Bool = true,
            showKeyAreaBorders: Bool = false,
            streamDeckView: @escaping () -> SDView
        ) {
            configuration = product.createConfiguration(serialNumber: serialNumber)

            self.product = product
            self.showOptions = showOptions
            self.streamDeckView = streamDeckView

            _showDeviceBezels = .init(initialValue: showDeviceBezels)
            _showKeyAreaBorders = .init(initialValue: showKeyAreaBorders)
        }

        public var body: some View {
            Group {
                if showOptions {
                    VStack(alignment: .center, spacing: 36) {
                        simulator
                        VStack {
                            Toggle("Show device bezels", isOn: $showDeviceBezels)
                            Toggle("Show guides", isOn: $showKeyAreaBorders)
                        }
                        .fixedSize()
                    }
                    .padding()
                } else {
                    simulator
                }
            }
            .onAppear {
                configuration.device.render(streamDeckView())
            }
            .environment(\.streamDeckViewContext, ._createDummyForSimulator(configuration.device))
        }

        @ViewBuilder
        private var simulator: some View {
            if product == .pedal {
                StreamDeckPedalSimulatorView(config: configuration, showTouchAreaBorders: $showKeyAreaBorders)
            } else {
                StreamDeckSimulatorView.create(
                    streamDeck: product,
                    config: configuration,
                    showDeviceBezels: $showDeviceBezels,
                    showKeyAreaBorders: $showKeyAreaBorders
                )
            }
        }
    }
}