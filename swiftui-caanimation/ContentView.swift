//
//  ContentView.swift
//  swiftui-caanimation
//
//  Created by Cameron Little on 2024-11-14.
//

import SwiftUI

struct ContentView: View {
    @State var value = 0.0

    var body: some View {
        VStack {
            Text("Value: \(value)")
            VStack {
                Button {
                    value = value > 0.5 ? 0.2 : 0.8
                } label: {
                    Text("Toggle (no animation)")
                }
                Button {
                    withAnimation {
                        value = value > 0.5 ? 0.2 : 0.8
                    }
                } label: {
                    Text("Toggle (default animation)")
                }
                Button {
                    withAnimation(.bouncy) {
                        value = value > 0.5 ? 0.2 : 0.8
                    }
                } label: {
                    Text("Toggle (bouncy)")
                }
                Button {
                    withAnimation(.easeInOut) {
                        value = value > 0.5 ? 0.2 : 0.8
                    }
                } label: {
                    Text("Toggle (ease in out)")
                }
                Button {
                    withAnimation(.timingCurve(0.17, 0.67, 0.96, -0.01)) {
                        value = value > 0.5 ? 0.2 : 0.8
                    }
                } label: {
                    Text("Toggle (custom curve)")
                }
            }
            HStack {
                let height: CGFloat = 400
                let d: CGFloat = 20
                VStack {
                    Text("SwiftUI").font(.caption)
                    ZStack {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: height)
                            .border(.blue)
                        Circle()
                            .fill(.red)
                            .position(y: (value * (height - d)) - ((height / 2) - d))
                            .frame(width: d, height: d)
                    }
                }
                VStack {
                    Text("Core Animation").font(.caption)
                    CustomSwiftUIView(value: $value)
                        .frame(height: height)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
