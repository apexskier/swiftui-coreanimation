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

    typealias PlatformView = UIView
    typealias ViewRepresentable = UIViewRepresentable
    typealias GestureRecognizer = UIGestureRecognizer
#else
    import AppKit

    typealias PlatformView = NSView
    typealias ViewRepresentable = NSViewRepresentable
    typealias GestureRecognizer = NSGestureRecognizer
#endif

class CustomPlatformView: PlatformView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var coordinator: CustomSwiftUIView.Coordinator?

    #if canImport(UIKit)
        init() {
            super.init(frame: .zero)
            self.layer.contentsScale = UIScreen.main.scale
            self.backgroundColor = .clear

            let gestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(Self.handleTap)
            )
            self.addGestureRecognizer(gestureRecognizer)
        }

        override class var layerClass: AnyClass {
            CustomLayer.self
        }
    #else
        init() {
            super.init(frame: .zero)
            self.wantsLayer = true

            let gestureRecognizer = NSClickGestureRecognizer(
                target: self,
                action: #selector(Self.handleTap)
            )
            self.addGestureRecognizer(gestureRecognizer)
        }

        // retina display support
        override func viewDidChangeBackingProperties() {
            super.viewDidChangeBackingProperties()
            if let layer,
                let backingScaleFactor = window?.backingScaleFactor
            {
                layer.contentsScale = backingScaleFactor
            }
        }

        // match iOS's coordinate system to ensure consistent rendering
        override var isFlipped: Bool {
            true
        }

        override func makeBackingLayer() -> CALayer {
            CustomLayer()
        }
    #endif

    @objc func handleTap(gestureRecognizer: GestureRecognizer) {
        guard let layer = layer as? CustomLayer, let coordinator else { return }
        coordinator.parent.value = (layer.presentation() ?? layer).value
        layer.removeAnimation(forKey: "value")
    }
}

struct CustomSwiftUIView: ViewRepresentable {
    @Binding var value: Double

    #if canImport(UIKit)
        typealias UIViewType = CustomPlatformView
    #else
        typealias NSViewType = CustomPlatformView
    #endif

    #if canImport(UIKit)
        func makeUIView(context: Context) -> CustomPlatformView {
            makeView(context: context)
        }
    #else
        func makeNSView(context: Context) -> CustomPlatformView {
            makeView(context: context)
        }
    #endif

    func makeView(context: Context) -> CustomPlatformView {
        let view = CustomPlatformView()
        view.coordinator = context.coordinator
        return view
    }

    #if canImport(UIKit)
        func updateUIView(_ uiView: CustomPlatformView, context: Context) {
            updateView(uiView, context: context)
        }
    #else
        func updateNSView(_ nsView: CustomPlatformView, context: Context) {
            updateView(nsView, context: context)
        }
    #endif

    func updateView(_ view: CustomPlatformView, context: Context) {
        (view.layer as? CustomLayer)?.update(
            with: context.transaction,
            value: value
        )
    }

    class Coordinator {
        var parent: CustomSwiftUIView

        init(_ parent: CustomSwiftUIView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
