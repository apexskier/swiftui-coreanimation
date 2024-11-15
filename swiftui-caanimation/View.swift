//
//  View.swift
//  swiftui-caanimation
//
//  Created by Cameron Little on 2024-11-14.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

typealias PlatformView = UIView
typealias GestureRecognizer = UIGestureRecognizer
#else
import AppKit

typealias PlatformView = NSView
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

        let doubleGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(Self.handleDoubleTap)
        )
        doubleGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleGestureRecognizer)
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

        let doubleGestureRecognizer = NSClickGestureRecognizer(
            target: self,
            action: #selector(Self.handleDoubleTap)
        )
        doubleGestureRecognizer.numberOfClicksRequired = 2
        self.addGestureRecognizer(doubleGestureRecognizer)
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

    @objc func handleDoubleTap(gestureRecognizer: GestureRecognizer) {
        guard let layer = layer as? CustomLayer, let coordinator else { return }
        withAnimation {
            coordinator.parent.value = (layer.presentation() ?? layer).value > 0.5 ? 0 : 1
        }
    }
}
