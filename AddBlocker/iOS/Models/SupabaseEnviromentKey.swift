//
//  SupabaseEnviromentKey.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import Supabase
import SwiftUI


struct SupabaseEnviromentKey: EnvironmentKey {
    static var defaultValue: SupabaseClient = .development
}

extension EnvironmentValues {
    var supabaseClient: SupabaseClient {
        get { self[SupabaseEnviromentKey.self] }
        set { self[SupabaseEnviromentKey.self] = newValue }
    }
}

