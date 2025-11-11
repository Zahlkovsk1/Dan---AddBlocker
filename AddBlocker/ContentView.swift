//
//  ContentView.swift
//  AddBlocker
//
//  Created by Gabons on 10/11/25.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "shield.lefthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("AdBlocker")
                    .font(.largeTitle)
                    .bold()
                
                Text("Block ads and trackers in Safari")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.blue)
                        Text("Enable extension in Settings")
                    }
                    
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.blue)
                        Text("Go to Safari → Extensions")
                    }
                    
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.blue)
                        Text("Turn on AdBlocker")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Button(action: {
                    openSettings()
                }) {
                    Text("Open Settings")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("")
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ContentView()
}
