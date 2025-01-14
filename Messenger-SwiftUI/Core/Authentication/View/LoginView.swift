

import SwiftUI

struct LoginView: View {
    enum FocusedField {
        case email, password
    }
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = LoginViewModel()
    @FocusState private var focusedField: FocusedField?
    @State private var appearAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemBlue).opacity(0.1),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // Logo Section
                        logoSection
                            .offset(y: appearAnimation ? 0 : -50)
                        
                        // Welcome Text
                        welcomeText
                            .offset(y: appearAnimation ? 0 : -30)
                        
                        // Input Fields
                        inputFields
                            .offset(y: appearAnimation ? 0 : 30)
                        
                        // Buttons Section
                        buttonSection
                            .offset(y: appearAnimation ? 0 : 50)
                        
                        // Divider Section
                        socialLoginSection
                            .offset(y: appearAnimation ? 0 : 70)
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                }
            }
        }
        .overlay {
            LoadingView(show: $viewModel.isLoading)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7)) {
                appearAnimation = true
            }
        }
    }
    
    // MARK: - Components
    
    private var logoSection: some View {
        Image(.messengerLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .padding()
            .background(
                Circle()
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
    }
    
    private var welcomeText: some View {
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.system(size: 28, weight: .bold))
            
            Text("Sign in to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            // Email Field
            CustomInputField(
                icon: "envelope.fill",
                placeholder: "Email",
                text: $viewModel.email,
                focusState: focusedField,
                field: .email
            )
            
            // Password Field
            CustomInputField(
                icon: "lock.fill",
                placeholder: "Password",
                text: $viewModel.password,
                isSecure: true,
                focusState: focusedField,
                field: .password
            )
            
            // Forgot Password
                    }
    }
    
    private var buttonSection: some View {
        VStack(spacing: 15) {
            Button {
                Task {
                    do {
                        try await viewModel.login()
                    } catch {
                        // Handle the error appropriately
                        print("Login error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 5)
                    )
            }
            .buttonStyle(CustomScaleButtonStyle())
        }
    }
    
    private var socialLoginSection: some View {
        VStack(spacing: 20) {
            // Divider
            HStack {
                Line()
                Text("Or continue with")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                Line()
            }
            
            // Social Login Buttons
            HStack(spacing: 20) {
                SocialLoginButton(image: "fbLogo", text: "Facebook")
                    .onTapGesture {
                        Alerter.shared.alert = Alert(title: Text("Coming soon"))
                    }
            }
            
            // Sign Up Link
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                Button {
                    coordinator.push(.registrationView)
                } label: {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 14))
            .padding(.top, 10)
        }
        .padding(.top, 20)
    }
}

// MARK: - Supporting Views

struct CustomInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var focusState: LoginView.FocusedField?
    let field: LoginView.FocusedField
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textContentType(.oneTimeCode)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusState == field ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: focusState)
    }
}

struct SocialLoginButton: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct Line: View {
    var body: some View {
        Rectangle()
            .fill(Color(.systemGray4))
            .frame(height: 1)
    }
}

struct CustomScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    LoginView()
        .environmentObject(Coordinator.shared)
}
