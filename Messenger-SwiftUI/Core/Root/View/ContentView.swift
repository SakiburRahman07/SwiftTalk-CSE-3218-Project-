

import SwiftUI

struct ContentView: View {
    @Bindable var viewModel = ContentViewModel()
    
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                InboxView()
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
