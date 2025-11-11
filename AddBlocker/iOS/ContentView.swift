//
//  ContentView.swift
//  AddBlocker
//
//  Created by Gabons on 10/11/25.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack(spacing: 20) {
                Text("AdBlocker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enable the extensions in Settings → Safari → Extensions")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding()
                
                Button("Open Settings") {
                    if let url = URL(string: "App-prefs:SAFARI") {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
        }
    }
}


#Preview {
    ContentView()
}
