import SwiftUI

struct RegistrationView: View {
    enum FocusedField {
        case email, password, fullname
    }
    
    @EnvironmentObject var coordinator: Coordinator
    
    @State var viewModel = RegistrationViewModel()
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            // Add a gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // Updated logo presentation
                Image(.messengerLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                    .background(
                        Circle()
                            .fill(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.1), radius: 10)
                    )
                
                // Welcome text
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Please fill in the form to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                textfield
                
                signUpButton
                
                Spacer()
                
                // Updated divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                
                signInText
            }
            .padding()
        }
        .overlay{
            LoadingView(show: $viewModel.isLoading)
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(Coordinator.shared)
}

extension RegistrationView{
    private var textfield: some View{
        VStack(spacing: 16) {
            // Email field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter your email", text: $viewModel.email)
                    .focused($focusedField, equals: .email)
                    .font(.regular(size: 16))
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Full name field
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter your fullname", text: $viewModel.fullname)
                    .focused($focusedField, equals: .fullname)
                    .font(.regular(size: 16))
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                SecureField("Enter your password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
                    .font(.regular(size: 16))
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
        .padding(.horizontal, 24)
        .onSubmit {
            signUp()
        }
    }
    
    private var signUpButton: some View {
        Button {
            signUp()
        } label: {
            Text("Sign up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 24)
    }
    
    private var signInText: some View {
        HStack(spacing: 3) {
            Text("Already have an account?")
                .font(.regular(size: 14))
                .foregroundColor(.gray)
            
            Text("Sign in")
                .font(.bold(size: 14))
                .foregroundColor(.blue)
        }
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture {
            coordinator.pop()
        }
    }
    
    //MARK: - funcs
    private func signUp(){
        if viewModel.email.isEmpty {
            focusedField = .email
        }else if viewModel.fullname.isEmpty{
            focusedField = .fullname
        }else if viewModel.password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            Task { try await viewModel.createUser()
                if AuthService.shared.userSession != nil{
                    coordinator.pop()
                }
            }
        }
    }
}

// Add custom text field style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
    }
}
