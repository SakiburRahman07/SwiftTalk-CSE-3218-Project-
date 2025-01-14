import SwiftUI

// First, create the delegate protocol for inbox styling
protocol InboxViewStyleDelegate {
    var backgroundColor: Color { get }
    var primaryTextColor: Color { get }
    var secondaryTextColor: Color { get }
    var accentColor: Color { get }
    var cardBackgroundColor: Color { get }
    var iconTint: Color { get }
}

// Default implementation
struct DefaultInboxStyle: InboxViewStyleDelegate {
    var backgroundColor: Color = Color(hex: "#F5F5F5")
    var primaryTextColor: Color = Color(hex: "#2C3E50")
    var secondaryTextColor: Color = Color(hex: "#7F8C8D")
    var accentColor: Color = Color(hex: "#3498DB")
    var cardBackgroundColor: Color = .white
    var iconTint: Color = Color(hex: "#3498DB")
}

// Dark theme implementation
struct DarkInboxStyle: InboxViewStyleDelegate {
    var backgroundColor: Color = Color(hex: "#1A1A1A")
    var primaryTextColor: Color = .white
    var secondaryTextColor: Color = Color(hex: "#A0A0A0")
    var accentColor: Color = Color(hex: "#3498DB")
    var cardBackgroundColor: Color = Color(hex: "#2D2D2D")
    var iconTint: Color = Color(hex: "#3498DB")
}

// Add these new theme implementations after the existing DarkInboxStyle
struct NightBlueInboxStyle: InboxViewStyleDelegate {
    var backgroundColor: Color = Color(hex: "#1A237E")
    var primaryTextColor: Color = .white
    var secondaryTextColor: Color = Color(hex: "#B3E5FC")
    var accentColor: Color = Color(hex: "#4FC3F7")
    var cardBackgroundColor: Color = Color(hex: "#283593")
    var iconTint: Color = Color(hex: "#4FC3F7")
}

struct ForestInboxStyle: InboxViewStyleDelegate {
    var backgroundColor: Color = Color(hex: "#1B5E20")
    var primaryTextColor: Color = .white
    var secondaryTextColor: Color = Color(hex: "#A5D6A7")
    var accentColor: Color = Color(hex: "#81C784")
    var cardBackgroundColor: Color = Color(hex: "#2E7D32")
    var iconTint: Color = Color(hex: "#81C784")
}

struct SunsetInboxStyle: InboxViewStyleDelegate {
    var backgroundColor: Color = Color(hex: "#37474F")
    var primaryTextColor: Color = .white
    var secondaryTextColor: Color = Color(hex: "#FFB74D")
    var accentColor: Color = Color(hex: "#FF9800")
    var cardBackgroundColor: Color = Color(hex: "#455A64")
    var iconTint: Color = Color(hex: "#FF9800")
}

// Add this enum for theme selection
enum ThemeOption: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case nightBlue = "Night Blue"
    case forest = "Forest"
    case sunset = "Sunset"
    
    var style: InboxViewStyleDelegate {
        switch self {
        case .light: return DefaultInboxStyle()
        case .dark: return DarkInboxStyle()
        case .nightBlue: return NightBlueInboxStyle()
        case .forest: return ForestInboxStyle()
        case .sunset: return SunsetInboxStyle()
        }
    }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .nightBlue: return "moon.stars.fill"
        case .forest: return "leaf.fill"
        case .sunset: return "sunset.fill"
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    let style: InboxViewStyleDelegate
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(style.secondaryTextColor)
            
            TextField("Search messages...", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(style.primaryTextColor)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.search)
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(style.secondaryTextColor)
                }
                .transition(.scale)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .animation(.spring(response: 0.3), value: searchText)
    }
}

struct InboxView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showNewMessageView: Bool = false
    @State private var showChat: Bool = false
    @State private var showToContactView: Bool = false
    @State private var showWeatherView: Bool = false
    @State private var teacherContactView: Bool = false
    @State private var selectedTheme: ThemeOption = .light
    @State private var searchText: String = ""

    private var user: User? {
        return viewModel.currentUser
    }

    private var filteredMessages: [Message] {
        guard !searchText.isEmpty else { return viewModel.recentMessage }
        return viewModel.recentMessage.filter { message in
            let nameMatch = message.user?.fullname.lowercased().contains(searchText.lowercased()) ?? false
            let messageMatch = message.messageText.lowercased().contains(searchText.lowercased())
            return nameMatch || messageMatch
        }
    }

    var body: some View {
        ZStack {
            selectedTheme.style.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedTheme.style.cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if searchText.isEmpty {
                            ActiveNowView()
                                .padding(.horizontal)
                        }
                        
                        if viewModel.isLoading {
                            loadDataShimmering
                        } else {
                            if filteredMessages.isEmpty {
                                if searchText.isEmpty {
                                    EmptyStateView()
                                } else {
                                    NoSearchResultsView(searchText: searchText)
                                }
                            } else {
                                MessagesListView(messages: filteredMessages, style: selectedTheme.style)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarHidden(true)
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

// Helper Views
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "message.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("You don't have any conversations!")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }
}

struct MessagesListView: View {
    let messages: [Message]
    let style: InboxViewStyleDelegate
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(messages) { message in
                NavigationLink(value: message) {
                    MessageRowView(message: message, style: style)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MessageRowView: View {
    let message: Message
    let style: InboxViewStyleDelegate
    
    var body: some View {
        HStack(spacing: 12) {
            CircularProfileImageView(user: message.user, size: .medium)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullname ?? "Unknown User")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(style.primaryTextColor)
                
                Text(message.messageText)
                    .font(.system(size: 14))
                    .foregroundColor(style.secondaryTextColor)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(message.timestampString)
                .font(.system(size: 12))
                .foregroundColor(style.secondaryTextColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(style.cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// Updated header view
extension InboxView {
    private var header: some View {
        VStack(spacing: 16) {
            // Top row with profile and actions
            HStack(spacing: 16) {
                if let user {
                    NavigationLink(value: Route.profile(user)) {
                        CircularProfileImageView(user: user, size: .small)
                            .overlay(
                                Circle()
                                    .stroke(selectedTheme.style.accentColor, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                } else {
                    ProgressView()
                        .frame(width: 40, height: 40)
                }

                Spacer()
                
                HStack(spacing: 20) {
                    Menu {
                        ForEach(ThemeOption.allCases, id: \.self) { theme in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedTheme = theme
                                }
                            }) {
                                Label(theme.rawValue, systemImage: theme.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(selectedTheme.style.iconTint)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(selectedTheme.style.cardBackgroundColor)
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                    
                    HeaderButton(
                        icon: "plus.circle.fill",
                        action: { showToContactView.toggle() },
                        style: selectedTheme.style
                    )
                    
                    HeaderButton(
                        icon: "sun.max.fill",
                        action: { showWeatherView.toggle() },
                        style: selectedTheme.style
                    )
                    
                    HeaderButton(
                        icon: "person.fill",
                        action: { teacherContactView.toggle() },
                        style: selectedTheme.style
                    )
                    
                    HeaderButton(
                        icon: "square.and.pencil.circle.fill",
                        action: {
                            showNewMessageView.toggle()
                            selectedUser = nil
                        },
                        style: selectedTheme.style
                    )
                }
            }
            
            // Search bar
            SearchBar(searchText: $searchText, style: selectedTheme.style)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedTheme.style.backgroundColor)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

// Header button component
struct HeaderButton: View {
    let icon: String
    let action: () -> Void
    let style: InboxViewStyleDelegate
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(style.iconTint)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(style.cardBackgroundColor)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .overlay(
                    Circle()
                        .stroke(style.accentColor.opacity(0.1), lineWidth: 1)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Add this button style for better interaction feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    InboxView()
}

extension InboxView {
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

struct NoSearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No results found for \"\(searchText)\"")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text("Try searching with a different term")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
        }
        .padding(.top, 40)
    }
}
