

import SwiftUI

enum ToggleState: String, CaseIterable {
    case off = "Off"
    case on = "On"
    case system = "System"
}

struct ChangeDarkLightView: View {
    @State private var colorScheme: String = "light" // Made mutable with @State
    @Binding var isShowDarkMode: Bool
    
    @State private var selectedToggle: ToggleState = .off
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.primary) // Use .primary to align with system colors
                
                Text("Dark mode")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .hAlign(.leading)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isShowDarkMode.toggle()
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: Binding(
                    get: { selectedToggle == .off },
                    set: { newValue in
                        if newValue { selectedToggle = .off }
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.off.rawValue)
                        .font(.body)
                        .bold()
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
                Toggle(isOn: Binding(
                    get: { selectedToggle == .on },
                    set: { newValue in
                        if newValue { selectedToggle = .on }
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.on.rawValue)
                        .font(.body)
                        .bold()
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
                Toggle(isOn: Binding(
                    get: { selectedToggle == .system },
                    set: { newValue in
                        if newValue { selectedToggle = .system }
                        updateColorScheme()
                    }
                )) {
                    Text(ToggleState.system.rawValue)
                        .font(.body)
                        .bold()
                }
                .toggleStyle(iOSCheckboxToggleStyle())
            }
            .padding(.vertical, 15)
            .hAlign(.leading)
            
            Text("If system is selected, Messenger will automatically adjust your appearance based on your device's system setting.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            setSelectedToggleFromColorScheme()
        }
    }
    
    private func updateColorScheme() {
        switch selectedToggle {
        case .off:
            colorScheme = "light"
        case .on:
            colorScheme = "dark"
        case .system:
            colorScheme = "system"
        }
    }
    
    private func setSelectedToggleFromColorScheme() {
        switch colorScheme {
        case "light":
            selectedToggle = .off
        case "dark":
            selectedToggle = .on
        default:
            selectedToggle = .system
        }
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation {
                configuration.isOn.toggle()
            }
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(.primary)
                    .imageScale(.large)
                
                configuration.label
                    .foregroundStyle(.primary)
            }
        })
    }
}

#Preview {
    ChangeDarkLightView(isShowDarkMode: .constant(true))
}
