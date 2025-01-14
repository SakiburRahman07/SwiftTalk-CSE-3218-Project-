import SwiftUI

protocol ChatThemeDelegate: AnyObject {
    func didChangeTheme(_ theme: ChatTheme)
}

enum ChatTheme {
    case classic
    case dark
    case nature
    case sunset
    case ocean
    case lavender
    case midnight
    case desert
    case forest
    case arctic
    case cherry
    case neon
    case autumn
    case winter
    case spring
    case cosmic
    
    var gradient: [Color] {
        switch self {
        case .classic:
            return [
                Color(hex: "EEF2FF"),  // Lighter indigo
                Color(hex: "F8FAFC").opacity(0.95)
            ]
        case .dark:
            return [
                Color(hex: "111827"),  // Deep slate
                Color(hex: "1F2937").opacity(0.98)
            ]
        case .nature:
            return [
                Color(hex: "ECFDF5"),  // Emerald tint
                Color(hex: "D1FAE5").opacity(0.8),
                Color(hex: "F0FDF4")
            ]
        case .sunset:
            return [
                Color(hex: "FFF7ED"),  // Warm orange
                Color(hex: "FFEDD5"),
                Color(hex: "FFF1F2").opacity(0.9)
            ]
        case .ocean:
            return [
                Color(hex: "F0F9FF"),  // Ocean blue
                Color(hex: "E0F2FE"),
                Color(hex: "F0FDFF").opacity(0.95)
            ]
        case .lavender:
            return [
                Color(hex: "F5F3FF"),  // Soft purple
                Color(hex: "EDE9FE"),
                Color(hex: "FAF5FF").opacity(0.9)
            ]
        case .midnight:
            return [
                Color(hex: "020617"),  // Deep midnight blue
                Color(hex: "0F172A"),
                Color(hex: "1E293B").opacity(0.95)
            ]
        case .desert:
            return [
                Color(hex: "FFFBEB"),  // Warm desert sand
                Color(hex: "FEF3C7"),
                Color(hex: "FDE68A").opacity(0.7)
            ]
        case .forest:
            return [
                Color(hex: "064E3B"),  // Deep forest green
                Color(hex: "065F46"),
                Color(hex: "047857").opacity(0.9)
            ]
        case .arctic:
            return [
                Color(hex: "F8FAFC"),  // Ice white
                Color(hex: "E2E8F0"),
                Color(hex: "CBD5E1").opacity(0.8)
            ]
        case .cherry:
            return [
                Color(hex: "FFF1F2"),  // Cherry blossom pink
                Color(hex: "FFE4E6"),
                Color(hex: "FECDD3").opacity(0.85)
            ]
        case .neon:
            return [
                Color(hex: "0D0D0D"),  // Deep black
                Color(hex: "170F2B"),   // Dark purple
                Color(hex: "1A1033").opacity(0.95)
            ]
        case .autumn:
            return [
                Color(hex: "FEF2F2"),  // Warm red
                Color(hex: "FEE2E2"),
                Color(hex: "FFEDD5").opacity(0.9)
            ]
        case .winter:
            return [
                Color(hex: "F1F5F9"),  // Cool blue-gray
                Color(hex: "E2E8F0"),
                Color(hex: "CBD5E1").opacity(0.95)
            ]
        case .spring:
            return [
                Color(hex: "F0FDF4"),  // Soft green
                Color(hex: "DCFCE7"),
                Color(hex: "D1FAE5").opacity(0.9)
            ]
        case .cosmic:
            return [
                Color(hex: "1E1B4B"),  // Deep space blue
                Color(hex: "312E81"),
                Color(hex: "3730A3").opacity(0.95)
            ]
        }
    }
    
    var textColor: Color {
        switch self {
        case .dark:
            return Color(hex: "F9FAFB")
        case .nature:
            return Color(hex: "065F46")
        case .sunset:
            return Color(hex: "9A3412")
        case .ocean:
            return Color(hex: "0C4A6E")
        case .lavender:
            return Color(hex: "6B21A8")
        case .midnight:
            return Color(hex: "F8FAFC")
        case .desert:
            return Color(hex: "92400E")
        case .forest:
            return Color(hex: "ECFDF5")
        case .arctic:
            return Color(hex: "0F172A")
        case .cherry:
            return Color(hex: "9F1239")
        case .neon:
            return Color(hex: "22D3EE")  // Bright cyan
        case .autumn:
            return Color(hex: "B91C1C")  // Deep red
        case .winter:
            return Color(hex: "1E293B")  // Slate
        case .spring:
            return Color(hex: "166534")  // Green
        case .cosmic:
            return Color(hex: "E0F2FE")  // Light blue
        default:
            return Color(hex: "1F2937")
        }
    }
    
    var accentColor: Color {
        switch self {
        case .classic:
            return Color(hex: "4F46E5")  // Indigo
        case .dark:
            return Color(hex: "60A5FA")  // Bright blue
        case .nature:
            return Color(hex: "059669")  // Emerald
        case .sunset:
            return Color(hex: "EA580C")  // Burnt orange
        case .ocean:
            return Color(hex: "0284C7")  // Ocean blue
        case .lavender:
            return Color(hex: "9333EA")  // Purple
        case .midnight:
            return Color(hex: "38BDF8")  // Bright blue
        case .desert:
            return Color(hex: "D97706")  // Desert orange
        case .forest:
            return Color(hex: "22C55E")  // Forest green
        case .arctic:
            return Color(hex: "0EA5E9")  // Ice blue
        case .cherry:
            return Color(hex: "E11D48")  // Cherry red
        case .neon:
            return Color(hex: "22D3EE")  // Cyan
        case .autumn:
            return Color(hex: "DC2626")  // Red
        case .winter:
            return Color(hex: "2563EB")  // Blue
        case .spring:
            return Color(hex: "16A34A")  // Green
        case .cosmic:
            return Color(hex: "818CF8")  // Indigo
        }
    }
    
    var secondaryTextColor: Color {
        switch self {
        case .dark:
            return Color(hex: "9CA3AF").opacity(0.9)
        case .nature:
            return Color(hex: "047857").opacity(0.8)
        case .sunset:
            return Color(hex: "C2410C").opacity(0.8)
        case .ocean:
            return Color(hex: "0369A1").opacity(0.8)
        case .lavender:
            return Color(hex: "7E22CE").opacity(0.8)
        case .midnight:
            return Color(hex: "94A3B8").opacity(0.9)
        case .desert:
            return Color(hex: "B45309").opacity(0.8)
        case .forest:
            return Color(hex: "D1FAE5").opacity(0.9)
        case .arctic:
            return Color(hex: "334155").opacity(0.8)
        case .cherry:
            return Color(hex: "BE123C").opacity(0.8)
        case .neon:
            return Color(hex: "22D3EE").opacity(0.7)
        case .autumn:
            return Color(hex: "DC2626").opacity(0.8)
        case .winter:
            return Color(hex: "475569").opacity(0.8)
        case .spring:
            return Color(hex: "16A34A").opacity(0.8)
        case .cosmic:
            return Color(hex: "A5B4FC").opacity(0.9)
        default:
            return Color(hex: "4B5563").opacity(0.9)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .dark:
            return Color(hex: "1F2937")
        case .nature:
            return Color(hex: "F0FDF4")
        case .sunset:
            return Color(hex: "FFF7ED")
        case .ocean:
            return Color(hex: "F0F9FF")
        case .lavender:
            return Color(hex: "F5F3FF")
        case .midnight:
            return Color(hex: "0F172A")
        case .desert:
            return Color(hex: "FFFBEB")
        case .forest:
            return Color(hex: "064E3B")
        case .arctic:
            return Color(hex: "F8FAFC")
        case .cherry:
            return Color(hex: "FFF1F2")
        default:
            return Color(hex: "FFFFFF")
        }
    }
    
    // New properties for enhanced visual effects
    var shadowColor: Color {
        switch self {
        case .dark:
            return Color.black.opacity(0.3)
        case .nature:
            return Color(hex: "059669").opacity(0.2)
        case .sunset:
            return Color(hex: "EA580C").opacity(0.2)
        case .ocean:
            return Color(hex: "0284C7").opacity(0.2)
        case .lavender:
            return Color(hex: "9333EA").opacity(0.2)
        case .midnight:
            return Color.black.opacity(0.4)
        case .desert:
            return Color(hex: "D97706").opacity(0.2)
        case .forest:
            return Color(hex: "22C55E").opacity(0.25)
        case .arctic:
            return Color(hex: "94A3B8").opacity(0.2)
        case .cherry:
            return Color(hex: "E11D48").opacity(0.2)
        default:
            return Color(hex: "4F46E5").opacity(0.2)
        }
    }
    
    var messageBubbleGradient: LinearGradient {
        switch self {
        case .classic:
            return LinearGradient(
                colors: [Color(hex: "4F46E5"), Color(hex: "4338CA")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .dark:
            return LinearGradient(
                colors: [Color(hex: "374151"), Color(hex: "1F2937")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .nature:
            return LinearGradient(
                colors: [Color(hex: "059669"), Color(hex: "047857")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [Color(hex: "EA580C"), Color(hex: "C2410C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ocean:
            return LinearGradient(
                colors: [Color(hex: "0284C7"), Color(hex: "0369A1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .lavender:
            return LinearGradient(
                colors: [Color(hex: "9333EA"), Color(hex: "7E22CE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .midnight:
            return LinearGradient(
                colors: [Color(hex: "0284C7"), Color(hex: "0369A1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .desert:
            return LinearGradient(
                colors: [Color(hex: "D97706"), Color(hex: "B45309")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .forest:
            return LinearGradient(
                colors: [Color(hex: "22C55E"), Color(hex: "15803D")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .arctic:
            return LinearGradient(
                colors: [Color(hex: "0EA5E9"), Color(hex: "0284C7")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .cherry:
            return LinearGradient(
                colors: [Color(hex: "E11D48"), Color(hex: "BE123C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .neon:
            return LinearGradient(
                colors: [Color(hex: "0D0D0D"), Color(hex: "170F2B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .autumn:
            return LinearGradient(
                colors: [Color(hex: "FEF2F2"), Color(hex: "FEE2E2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .winter:
            return LinearGradient(
                colors: [Color(hex: "F1F5F9"), Color(hex: "E2E8F0")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .spring:
            return LinearGradient(
                colors: [Color(hex: "F0FDF4"), Color(hex: "DCFCE7")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .cosmic:
            return LinearGradient(
                colors: [Color(hex: "1E1B4B"), Color(hex: "312E81")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var materialEffect: Material {
        switch self {
        case .dark:
            return .ultraThinMaterial
        default:
            return .regularMaterial
        }
    }
    
    var inputFieldBackground: Color {
        switch self {
        case .dark, .midnight, .neon, .cosmic:
            return Color(hex: "374151").opacity(0.8)
        case .nature:
            return Color(hex: "ECFDF5").opacity(0.9)
        case .sunset:
            return Color(hex: "FFF7ED").opacity(0.9)
        case .ocean:
            return Color(hex: "F0F9FF").opacity(0.9)
        case .lavender:
            return Color(hex: "F5F3FF").opacity(0.9)
        case .desert:
            return Color(hex: "FFFBEB").opacity(0.9)
        case .forest:
            return Color(hex: "064E3B").opacity(0.8)
        case .arctic:
            return Color(hex: "F8FAFC").opacity(0.9)
        case .cherry:
            return Color(hex: "FFF1F2").opacity(0.9)
        case .autumn:
            return Color(hex: "FEF2F2").opacity(0.9)
        case .winter:
            return Color(hex: "F1F5F9").opacity(0.9)
        case .spring:
            return Color(hex: "F0FDF4").opacity(0.9)
        default:
            return backgroundColor.opacity(0.9)
        }
    }
}

struct ChatView: View {
    enum FocusedField {
        case textInput
    }
    
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChatViewModel
    @FocusState private var focusedField: FocusedField?
    
    let user: User
    
    @State private var currentTheme: ChatTheme = .classic
    @State private var showThemeMenu: Bool = false
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    @State private var scrollId: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: currentTheme.gradient),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Enhanced title bar
                title
                    .background(.ultraThinMaterial)
                    .overlay(
                        Divider()
                            .opacity(0.3)
                            .offset(y: 8)
                    )
                
                ScrollView(showsIndicators: false) {
                    // Enhanced header with animation
                    header
                        .padding(.top)
                        .transition(.move(edge: .top))
                    
                    // Messages
                    VStack(spacing: 12) {
                        ForEach(viewModel.message.reversed()) { message in
                            ChatMessageCell(message: message, viewModel: viewModel)
                                .environment(\.theme, currentTheme)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.9).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .padding(.horizontal, 8)
                    .scrollTargetLayout()
                    .scrollDismissesKeyboard(.never)
                }
                .scrollPosition(id: .constant(viewModel.scrolledID?.id), anchor: .bottom)
                .refreshable {
                    withAnimation {
                        viewModel.loadMoreMessages()
                    }
                }

                Spacer()
                
                // Enhanced message input
                messageInput
                    .background(.ultraThinMaterial)
            }
        }
        .preferredColorScheme(currentTheme == .dark ? .dark : .light)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                let currentId = UserService.shared.currentUser?.id
                //Because In Chat view ForEach(viewModel.message.REVERSED()) so -> lastMesage = message.filter{}.first or message.filter{}.reversed().last
                let lastMesage: Message? = viewModel.message.filter({ $0.toId == currentId }).first ?? nil
                
                if lastMesage?.unread == true{
                    viewModel.updateUnreadMessage(lastMesage: lastMesage)
                }
            }
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}

extension ChatView{
    private var title: some View{
        HStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    dismiss()
                    viewModel.scrolledID = viewModel.message.last
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                    
                    Text("Back")
                        .font(.system(size: 14.5, weight: .semibold))
                }
                .foregroundStyle(currentTheme.accentColor)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(user.fullname)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(currentTheme.textColor)
                
                Text("Online")
                    .font(.system(size: 12))
                    .foregroundColor(currentTheme == .dark || currentTheme == .midnight || currentTheme == .neon || currentTheme == .cosmic
                        ? .green.opacity(0.8)
                        : .green)
            }
            
            Spacer()
            
            Menu {
                ForEach([
                    (theme: ChatTheme.classic, icon: "circle.fill", label: "Classic"),
                    (theme: ChatTheme.dark, icon: "moon.fill", label: "Dark"),
                    (theme: ChatTheme.nature, icon: "leaf.fill", label: "Nature"),
                    (theme: ChatTheme.sunset, icon: "sun.horizon.fill", label: "Sunset"),
                    (theme: ChatTheme.ocean, icon: "water.waves", label: "Ocean"),
                    (theme: ChatTheme.lavender, icon: "flower.fill", label: "Lavender"),
                    (theme: ChatTheme.midnight, icon: "star.fill", label: "Midnight"),
                    (theme: ChatTheme.desert, icon: "sun.max.fill", label: "Desert"),
                    (theme: ChatTheme.forest, icon: "tree.fill", label: "Forest"),
                    (theme: ChatTheme.arctic, icon: "snowflake", label: "Arctic"),
                    (theme: ChatTheme.cherry, icon: "heart.fill", label: "Cherry"),
                    (theme: ChatTheme.neon, icon: "sparkles", label: "Neon"),
                    (theme: ChatTheme.autumn, icon: "leaf.fill", label: "Autumn"),
                    (theme: ChatTheme.winter, icon: "snow", label: "Winter"),
                    (theme: ChatTheme.spring, icon: "cloud.sun.fill", label: "Spring"),
                    (theme: ChatTheme.cosmic, icon: "star.circle.fill", label: "Cosmic")
                ], id: \.label) { themeOption in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentTheme = themeOption.theme
                        }
                    }) {
                        Label(themeOption.label, systemImage: themeOption.icon)
                            .foregroundColor(themeOption.theme.accentColor)
                    }
                }
            } label: {
                Image(systemName: "paintbrush.fill")
                    .foregroundStyle(currentTheme.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private var header: some View{
        VStack(spacing: 16) {
            CircularProfileImageView(user: user, size: .xLarge)
                .shadow(color: currentTheme.shadowColor, radius: 5)
                .overlay(
                    Circle()
                        .fill(currentTheme == .dark || currentTheme == .midnight || currentTheme == .neon || currentTheme == .cosmic
                            ? .green.opacity(0.8)
                            : .green)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(currentTheme.backgroundColor, lineWidth: 2)
                        )
                        .offset(x: 30, y: 30)
                )
            
            VStack(spacing: 6) {
                Text(user.fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(currentTheme.textColor)
                
                Text("Active Now")
                    .font(.system(size: 14))
                    .foregroundStyle(currentTheme.secondaryTextColor)
            }
        }
        .padding(.vertical)
    }
    
    private var messageInput: some View{
        ZStack(alignment: .trailing) {
            TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                .focused($focusedField, equals: .textInput)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .padding(.trailing, 48)
                .font(.system(size: 15))
                .foregroundColor(currentTheme.textColor)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(currentTheme.inputFieldBackground)
                        .shadow(color: currentTheme.shadowColor, radius: 2, y: 1)
                )
                .tint(currentTheme.accentColor)
            
            Button {
                withAnimation(.spring()) {
                    viewModel.sendMessage()
                    viewModel.scrolledID = viewModel.message.last
                    viewModel.messageText = ""
                    focusedField = nil
                }
            } label: {
                Circle()
                    .fill(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                          ? currentTheme.secondaryTextColor.opacity(0.3)
                          : currentTheme.accentColor)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "paperplane.fill")
                            .imageScale(.small)
                            .foregroundStyle(currentTheme.backgroundColor)
                            .rotationEffect(.degrees(45))
                    )
            }
            .padding(.trailing, 24)
            .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

// Add theme environment key
struct ThemeKey: EnvironmentKey {
    static let defaultValue: ChatTheme = .classic
}

extension EnvironmentValues {
    var theme: ChatTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
