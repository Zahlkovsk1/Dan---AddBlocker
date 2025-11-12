//
//  AppSupabaseConfig.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import Foundation
import Supabase

struct AppSupabaseConfig {
    static let url = URL(string: "https://lawnvwgaigkcezpesvfp.supabase.co")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxhd252d2dhaWdrY2V6cGVzdmZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5MzIzMjksImV4cCI6MjA3ODUwODMyOX0.dfguy1FazCeiOYmac75Qfn8VdVZCXtFBXZVfToh1g5g"
    static let base = "lawnvwgaigkcezpesvfp"
}

extension SupabaseClient {
    static var development: SupabaseClient {
        SupabaseClient(supabaseURL: AppSupabaseConfig.url, supabaseKey: AppSupabaseConfig.anonKey)
    }
}
