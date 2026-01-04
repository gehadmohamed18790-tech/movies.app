//
//  TabView.swift
//  NewApp6
//
//  Created by Gehad Mohamed on 25/12/2025.
//
import SwiftUI

struct SettingsView: View {
    // الإضاءة
    @AppStorage("isLightMode") private var isLightMode = false
    
    // اللغة
    @State private var selectedLanguage = "English"
    let languages = ["English", "Arabic"]
    
    // حجم الخط
    @State private var fontSize: Double = 16
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle("Light Mode", isOn: $isLightMode)
                        .preferredColorScheme(isLightMode ? .light : .dark)
                }
                
                Section("Language") {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Font Size") {
                    VStack {
                        Slider(value: $fontSize, in: 12...30, step: 1)
                        Text("Current font size: \(Int(fontSize))")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
