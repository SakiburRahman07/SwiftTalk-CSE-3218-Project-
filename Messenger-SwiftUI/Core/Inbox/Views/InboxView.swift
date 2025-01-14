import SwiftUI

struct InboxView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showNewMessageView: Bool = false
    @State private var showChat: Bool = false
    @State private var showToContactView: Bool = false
    @State private var showWeatherView: Bool = false
    @State private var teacherContactView: Bool = false

    private var user: User? {
        return viewModel.currentUser
    }

    var body: some View {
        VStack {
            header

            ScrollView(showsIndicators: false) {
                ActiveNowView()

                if viewModel.isLoading {
                    loadDataShimmering
                } else {
                    if viewModel.recentMessage.isEmpty {
                        Text("You don't have any conversations!")
                            .padding(.top, 20)
                            .font(.regular(size: 15))
                            .foregroundStyle(.text).opacity(0.6)
                    } else {
                        LazyVStack {
                            ForEach(viewModel.recentMessage) { message in
                                NavigationLink(value: message) {
                                    InboxRowView(message: message)
                                }
                            }
                        }
                        .padding(.horizontal, 13)
                    }
                }
            }
        }
        .onChange(of: selectedUser, { _, newValue in
            showChat = newValue != nil
        })
        .fullScreenCover(isPresented: $showNewMessageView) {
            NewMessageView(selectedUser: $selectedUser)
        }
        .fullScreenCover(isPresented: $showToContactView) {
            PendingContactView()
        }
        .fullScreenCover(isPresented: $showWeatherView) {
            WeatherView()
        }
        .fullScreenCover(isPresented: $teacherContactView) { // Corrected here
            TeacherContactView()
        }
        .navigationDestination(isPresented: $showChat) {
            if let user = selectedUser {
                ChatView(user: user)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    InboxView()
}

extension InboxView {
    private var header: some View {
        HStack {
            if let user {
                NavigationLink(value: Route.profile(user)) {
                    CircularProfileImageView(user: user, size: .small)
                }
            } else {
                ProgressView()
                    .frame(width: 40, height: 40)
            }

            Text("Chats")
                .font(.semibold(size: 24))
                .foregroundStyle(.text)

            Spacer()
            
            Button {
                // Logic to redirect to the new view
                showToContactView.toggle() // Toggle a state variable to present the view
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
            
            Spacer()
            
            Button {
                // Logic to redirect to the new view
                showWeatherView.toggle() // Toggle a state variable to present the view
            } label: {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
            
            Spacer()
            
            Button {
                // Logic to redirect to the new view
                teacherContactView.toggle() // Toggle a state variable to present the view
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
            
            Spacer()

            Button {
                showNewMessageView.toggle()
                self.selectedUser = nil
            } label: {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
        }
        .hAlign(.leading)
        .padding(.horizontal)
    }
    
    private var loadDataShimmering: some View {
        VStack {
            ForEach(0..<4) { _ in
                HStack(spacing: 10){
                    Circle()
                        .frame(width: 56, height: 56, alignment: .center)
                        .foregroundStyle(.text).opacity(0.7)
                    
                    Rectangle()
                        .foregroundColor(.text).opacity(0.6)
                        .cornerRadius(13)
                }
                .frame(width: UIScreen.main.bounds.width - 25 ,height: 72)
                .shimmering(bandSize: 1)
            }
        }
        .padding(.horizontal,13)
    }
}
