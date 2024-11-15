//
//  Layer.swift
//  swiftui-caanimation
//
//  Created by Cameron Little on 2024-11-14.
//

import Foundation
import QuartzCore
import SwiftUI

nonisolated(unsafe) private let fontAttributes: [NSAttributedString.Key: Any] = {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    paragraphStyle.allowsDefaultTighteningForTruncation = true

#if canImport(UIKit)
    let font = UIFont.systemFont(ofSize: 20)
    let textColor = UIColor(SwiftUI.Color.black)
#else
    let font = NSFont.systemFont(ofSize: 20)
    let textColor = NSColor(SwiftUI.Color.black)
#endif

    return [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: textColor,
    ] as [NSAttributedString.Key: Any]
}()

class CustomLayer: CALayer {
    @NSManaged var value: CGFloat

    private var diameter: CGFloat = 20

    override init() {
        super.init()

        self.needsDisplayOnBoundsChange = true
        self.drawsAsynchronously = true
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(in ctx: CGContext) {
        ctx.clear(bounds)

        // set graphics context to support NSString drawing
#if canImport(UIKit)
        UIGraphicsPushContext(ctx)
#else
        NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: true)
#endif

        "\(value)".draw(
            in: bounds,
            withAttributes: fontAttributes
        )

        ctx.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
        ctx.setLineWidth(2)
        ctx.stroke(bounds)

        ctx.setFillColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
        ctx.fillEllipse(
            in: CGRect(
                origin: CGPoint(
                    x: (bounds.width - diameter) / 2,
                    y: (bounds.height - diameter) * value
                ),
                size: CGSize(width: diameter, height: diameter)
            )
        )
    }

    static private let animationKey = "value-animation-key"
    static private let animationKeyPath = \CustomLayer.value
    static private var nsAnimationKeyPath: String {
        NSExpression(forKeyPath: animationKeyPath).keyPath
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        key == nsAnimationKeyPath || super.needsDisplay(forKey: key)
    }

    func update(with transaction: SwiftUI.Transaction, value: Double) {
        CATransaction.begin()

        let fromValue = (presentation() ?? self).value
        let toValue = CGFloat(value)
        self.value = toValue

        removeAnimation(forKey: Self.animationKey)

        if let caAnimation = transaction.animation?.caAnimation {
            switch caAnimation {
            case let caAnimation as CASpringAnimation:
                // TODO: to fully match SwiftUI's animations, we need to track the velocity of the current animation, if still in progress, and apply that as the initial velocity here. I suspect this will require using the blendDuration proprety of the SwiftUI animation
                caAnimation.keyPath = Self.nsAnimationKeyPath
                caAnimation.fromValue = fromValue
                caAnimation.toValue = toValue
                caAnimation.duration = caAnimation.settlingDuration
            case let caAnimation as CABasicAnimation:
                caAnimation.keyPath = Self.nsAnimationKeyPath
                caAnimation.fromValue = fromValue
                caAnimation.toValue = toValue
            default:
                fatalError("Unsupported animation type \(caAnimation)")
            }

            add(caAnimation, forKey: Self.animationKey)
        }

        CATransaction.commit()

        setNeedsDisplay()
    }
}
