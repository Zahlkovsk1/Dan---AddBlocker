//
//  AppSupabaseConfig.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import Foundation
import Supabase

struct AppSupabaseConfig {
    static let url = URL(string: "https://ebgasqvrezvfouyssqnv.supabase.co")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImViZ2FzcXZyZXp2Zm91eXNzcW52Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2MzEzNjQsImV4cCI6MjA3NDIwNzM2NH0.8vFzcDNl9dXhJ0cILDFbZApp8Oq5IvSZC7VLxyrAq5w"
    static let base = "ebgasqvrezvfouyssqnv"
}

extension SupabaseClient {
    static var development: SupabaseClient {
        SupabaseClient(supabaseURL: AppSupabaseConfig.url, supabaseKey: AppSupabaseConfig.anonKey)
    }
}
