// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(macOS 10.15, *)
struct ContentView: View {
    @State private var isExpanded = false

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)

            VStack {
                if isExpanded {
                    ExpandedView()
                        .transition(.move(edge: .top))
                } else {
                    NotchView()
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                }
            }
            .padding(.top, 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

@available(macOS 10.15, *)
struct NotchView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black)
            .frame(width: 200, height: 50)
            .overlay(
                Text("Dynamic Island")
                    .foregroundColor(.white)
            )
            .padding(.top, 20)
    }
}

@available(macOS 10.15, *)
struct ExpandedView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black)
            .frame(width: 300, height: 200)
            .overlay(
                VStack {
                    Text("Expanded View")
                        .foregroundColor(.white)
                    Text("More information here...")
                        .foregroundColor(.white)
                }
            )
            .padding(.top, 20)
    }
}

@main
@available(macOS 11.0, *)
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .windowStyle(DefaultWindowStyle())
    }
}
