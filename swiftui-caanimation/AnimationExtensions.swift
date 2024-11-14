import SwiftUI

extension CASpringAnimation {
    func apply(response: CGFloat, dampingFraction: CGFloat) {
        let omegaN = 2 * .pi / response
        stiffness = omegaN * omegaN * mass
        damping = dampingFraction * 2 * sqrt(stiffness * mass)
    }
}

nonisolated(unsafe) let fluidSpringAnimationRegex =
#/FluidSpringAnimation\(response: (?<response>\d+\.\d+), dampingFraction: (?<dampingFraction>\d+\.\d+), blendDuration: (?<blendDuration>\d+\.\d+)\)/#
let linearAnimationCubicSolver =
"SwiftUI.UnitCurve.CubicSolver(ax: -2.0, bx: 3.0, cx: 0.0, ay: -2.0, by: 3.0, cy: 0.0)"
let easeInOutAnimationCubicSolver =
"SwiftUI.UnitCurve.CubicSolver(ax: 0.52, bx: -0.78, cx: 1.26, ay: -2.0, by: 3.0, cy: 0.0)"
let easeOutAnimationCubicSolver =
"SwiftUI.UnitCurve.CubicSolver(ax: -0.7399999999999998, bx: 1.7399999999999998, cx: 0.0, ay: -2.0, by: 3.0, cy: 0.0)"
let easeInAnimationCubicSolver =
"SwiftUI.UnitCurve.CubicSolver(ax: -0.7400000000000002, bx: 0.4800000000000002, cx: 1.26, ay: -2.0, by: 3.0, cy: 0.0)"
nonisolated(unsafe) let bezierAnimationRegex =
#/BezierAnimation\(duration: (?<duration>\d+\.\d+), curve: \(extension in SwiftUI\):(?<cubicSolver>SwiftUI.UnitCurve.CubicSolver\(ax: (?<ax>-?\d+\.\d+), bx: (?<bx>-?\d+\.\d+), cx: (?<cx>-?\d+\.\d+), ay: (?<ay>-?\d+\.\d+), by: (?<by>-?\d+\.\d+), cy: (?<cy>-?\d+\.\d+)\))\)/#
nonisolated(unsafe) let springAnimationRegex =
#/SpringAnimation\(mass: (?<mass>-?\d+\.\d+), stiffness: (?<stiffness>-?\d+\.\d+), damping: (?<damping>-?\d+\.\d+), initialVelocity: SwiftUI._Velocity<Swift.Double>\(valuePerSecond: (?<initialVelocity>-?\d+\.\d+)\)\)/#

extension Animation {
    var caAnimation: CAAnimation {
        do {
            if description == "DefaultAnimation()" {
                // defaults changed in more recent versions
                if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                    let caAnimation = CASpringAnimation()
                    caAnimation.apply(response: 0.55, dampingFraction: 1)
                    return caAnimation
                } else {
                    let caAnimation = CABasicAnimation()
                    caAnimation.timingFunction = .init(name: .easeInEaseOut)
                    caAnimation.duration = 0.35
                    return caAnimation
                }
            }
            if let springParameters = try fluidSpringAnimationRegex.wholeMatch(in: description) {
                let caAnimation = CASpringAnimation()
                caAnimation.apply(
                    response: CGFloat(Float(springParameters.response)!),
                    dampingFraction: CGFloat(Float(springParameters.dampingFraction)!)
                )
                return caAnimation
            }
            if let springParameters = try springAnimationRegex.wholeMatch(in: description) {
                let caAnimation = CASpringAnimation()
                caAnimation.mass = CGFloat(Float(springParameters.mass)!)
                caAnimation.stiffness = CGFloat(Float(springParameters.stiffness)!)
                caAnimation.damping = CGFloat(Float(springParameters.damping)!)
                caAnimation.initialVelocity = CGFloat(Float(springParameters.initialVelocity)!)
                return caAnimation
            }
            if let bezierParameters = try bezierAnimationRegex.wholeMatch(in: description) {
                let caAnimation = CABasicAnimation()
                caAnimation.duration = Double(bezierParameters.duration)!
                switch bezierParameters.cubicSolver {
                case linearAnimationCubicSolver:
                    caAnimation.timingFunction = .init(name: .linear)
                case easeInOutAnimationCubicSolver:
                    caAnimation.timingFunction = .init(name: .easeInEaseOut)
                case easeOutAnimationCubicSolver:
                    caAnimation.timingFunction = .init(name: .easeOut)
                case easeInAnimationCubicSolver:
                    caAnimation.timingFunction = .init(name: .easeIn)
                default:
                    print("Warning: Bezier animations are probably not working")
                    // TODO: I don't think this is right.
                    let caAnimation = CABasicAnimation()
                    let ax = Float(bezierParameters.ax)!
                    let ay = Float(bezierParameters.ay)!
                    let bx = Float(bezierParameters.bx)!
                    let by = Float(bezierParameters.by)!
                    caAnimation.timingFunction = .init(controlPoints: ax, ay, bx, by)
                }
                return caAnimation
            }
            fatalError("Unsupported animation type \(description)")
        } catch {
            fatalError("Error parsing animation description: \(error)")
        }
    }
}
