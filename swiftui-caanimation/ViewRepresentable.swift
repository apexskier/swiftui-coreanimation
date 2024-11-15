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

    typealias ViewRepresentable = UIViewRepresentable
#else
    import AppKit

    typealias ViewRepresentable = NSViewRepresentable
#endif

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
