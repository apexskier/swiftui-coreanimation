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
            }
            CustomSwiftUIView(value: $value)
                .frame(width: 200, height: 400)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
