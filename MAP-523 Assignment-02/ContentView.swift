
//
//  ContentView.swift
//  Assignment-02
//
//  Created by Romil on 2025-09-30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                Part1View()
                
            }
            .tabItem {
                Label("Part 1", systemImage: "1.circle")
            }

            NavigationStack {
                Part2View()
                    
                    
            }
            .tabItem {
                Label("Part 2", systemImage: "2.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
