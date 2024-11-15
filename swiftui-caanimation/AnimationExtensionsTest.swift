//
//  Test.swift
//  swiftui-caanimationTests
//
//  Created by Cameron Little on 2024-11-14.
//

import CoreGraphics
import SwiftUICore
import Testing

extension CABasicAnimation {
    func matches(
        _ actual: CAAnimation,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(type(of: self) == type(of: actual), sourceLocation: sourceLocation)
        #expect(timingFunction == actual.timingFunction, sourceLocation: sourceLocation)
        #expect(duration == actual.duration, sourceLocation: sourceLocation)
    }
}

@Suite
struct AnimationExtensionTests {
    @Test
    func testLinear() async throws {
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .linear)
        expected.duration = 0.35
        let actual = Animation.linear.caAnimation
        expected.matches(actual)
    }

    @Test
    func testLinearWithDuration() async throws {
        let duration = 0.234
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .linear)
        expected.duration = duration
        let actual = Animation.linear(duration: duration).caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseInOut() async throws {
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        expected.duration = 0.35
        let actual = Animation.easeInOut.caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseInOutWithDuration() async throws {
        let duration = 0.234
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        expected.duration = duration
        let actual = Animation.easeInOut(duration: duration).caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseOut() async throws {
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeOut)
        expected.duration = 0.35
        let actual = Animation.easeOut.caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseOutWithDuration() async throws {
        let duration = 0.234
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeOut)
        expected.duration = duration
        let actual = Animation.easeOut(duration: duration).caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseIn() async throws {
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeIn)
        expected.duration = 0.35
        let actual = Animation.easeIn.caAnimation
        expected.matches(actual)
    }

    @Test
    func testEaseInWithDuration() async throws {
        let duration = 0.234
        let expected = CABasicAnimation()
        expected.timingFunction = CAMediaTimingFunction(name: .easeIn)
        expected.duration = duration
        let actual = Animation.easeIn(duration: duration).caAnimation
        expected.matches(actual)
    }

    @Test
    func testFluidSpring() async throws {
        let expected = CASpringAnimation()
        expected.apply(response: 14, dampingFraction: 43)
        let actual = Animation.spring(response: 14, dampingFraction: 43).caAnimation
        expected.matches(actual)
    }

    @Test
    func testSpring() async throws {
        let expected = CASpringAnimation()
        expected.mass = 2
        expected.stiffness = 3
        expected.initialVelocity = 4
        let actual = Animation.interpolatingSpring(mass: 2, stiffness: 3, damping: 4).caAnimation
        expected.matches(actual)
    }
}