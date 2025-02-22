

import Foundation

@MainActor
class LoginViewModel: ObservableObject{
    
    @Published var isLoading = false
    
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws{
        isLoading = true
        try await AuthService.shared.login(withEmail: email, password: password)
        isLoading = false
    }
}
