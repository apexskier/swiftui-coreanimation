//
//  ViewRepresentable.swift
//  swiftui-caanimation
//
//  Created by Cameron Little on 2024-11-14.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
    import UIKit

    class CustomPlatformView: UIView {
        init() {
            super.init(frame: .zero)
            self.layer.contentsScale = UIScreen.main.scale
            self.layer.delegate = self
            self.backgroundColor = .clear
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override class var layerClass: AnyClass {
            CustomLayer.self
        }
    }

    struct CustomSwiftUIView: UIViewRepresentable {
        var value: Double

        func makeUIView(context: Context) -> CustomPlatformView {
            makeView(context: context)
        }

        func updateUIView(_ uiView: CustomPlatformView, context: Context) {
            updateView(uiView, context: context)
        }
    }
#else
    import AppKit

    class CustomPlatformView: NSView {
        init() {
            super.init(frame: .zero)
            self.clipsToBounds = true
            self.wantsLayer = true
            self.layerContentsRedrawPolicy = .never
            self.layerContentsPlacement = .center
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func makeBackingLayer() -> CALayer {
            CustomLayer()
        }
    }

    struct CustomSwiftUIView: NSViewRepresentable {
        var value: Double

        func makeNSView(context: Context) -> CustomPlatformView {
            makeView(context: context)
        }

        func updateNSView(_ nsView: CustomPlatformView, context: Context) {
            updateView(nsView, context: context)
        }
    }
#endif

extension CustomSwiftUIView {
    func makeView(context: Context) -> CustomPlatformView {
        CustomPlatformView()
    }

    func updateView(_ view: CustomPlatformView, context: Context) {
        (view.layer as? CustomLayer)?.update(
            with: context.transaction, value: value)
    }
}
