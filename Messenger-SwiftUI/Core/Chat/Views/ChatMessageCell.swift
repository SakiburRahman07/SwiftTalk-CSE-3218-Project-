import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    @Environment(\.theme) var currentTheme
    @StateObject var viewModel: ChatViewModel
    @State private var showTime = false
    @State private var showingAlertUnsend = false
    @State private var isAppeared = false
    @State private var isShowTime = false
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                messageFromCurrentUser
            } else {
                messageFromPartner
            }
        }
        .padding(.horizontal, 8)
        .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive) { content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                .blur(radius: phase.isIdentity ? 0 : 8)
        }
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : (message.isFromCurrentUser ? 50 : -50))
        .onAppear {
            withAnimation(.spring(response: 0.3)) {
                isAppeared = true
            }
        }
        .alert(isPresented: $showingAlertUnsend) {
            Alert(
                title: Text("Unsend Message?")
                    .font(.system(size: 17, weight: .semibold)),
                message: Text("This action cannot be undone")
                    .font(.system(size: 14)),
                primaryButton: .default(
                    Text("Cancel")
                        .foregroundColor(currentTheme.accentColor)
                ),
                secondaryButton: .destructive(
                    Text("Unsend"),
                    action: {
                        if let id = message.messageID {
                            viewModel.unsendMessage(idMessage: id)
                        }
                    }
                )
            )
        }
    }
    
    private var messageFromCurrentUser: some View {
        VStack(alignment: .trailing, spacing: 4) {
            timeMessage(size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            
            if message.isRecalled {
                unsendMessageText(text: "You unsent a message", size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                messageText(
                    bgr: currentTheme.messageBubbleGradient,
                    fgr: .white,
                    size: UIScreen.main.bounds.width / 1.5,
                    alignment: .trailing
                )
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isShowTime.toggle()
            }
        }
    }
    
    private var messageFromPartner: some View {
        HStack(alignment: .bottom, spacing: 8) {
            CircularProfileImageView(user: message.user, size: .xxSmall)
                .shadow(color: currentTheme.shadowColor, radius: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                if message.isRecalled {
                    timeMessage(size: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                    unsendMessageText(
                        text: "\(message.user?.firstName ?? "Someone") unsent a message",
                        size: UIScreen.main.bounds.width / 1.75,
                        alignment: .leading
                    )
                } else {
                    timeMessage(size: .infinity, alignment: .leading)
                    messageText(
                        bgr: currentTheme.inputFieldBackground,
                        fgr: currentTheme.textColor,
                        size: .infinity,
                        alignment: .leading
                    )
                }
            }
            
            Spacer()
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isShowTime.toggle()
            }
        }
    }
    
    private func messageText(bgr: Color, fgr: Color, size: CGFloat, alignment: Alignment) -> some View {
        Text(message.messageText)
            .font(.system(size: 15))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(bgr)
            .foregroundStyle(fgr)
            .clipShape(shapeBubble)
            .shadow(color: currentTheme.shadowColor,
                   radius: 8, x: 0, y: 2)
            .contextMenu {
                contextMenu
            }
            .frame(maxWidth: size, alignment: alignment)
    }
    
    private func messageText(bgr: LinearGradient, fgr: Color, size: CGFloat, alignment: Alignment) -> some View {
        Text(message.messageText)
            .font(.system(size: 15))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(bgr)
            .foregroundStyle(fgr)
            .clipShape(shapeBubble)
            .shadow(color: currentTheme.shadowColor, radius: 8, x: 0, y: 2)
            .contextMenu {
                contextMenu
            }
            .frame(maxWidth: size, alignment: alignment)
    }
    
    private var contextMenu: some View {
        VStack {
            Button {
                UIPasteboard.general.string = message.messageText
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
                    .font(.system(size: 14))
                    .foregroundColor(currentTheme.accentColor)
            }
            
            if UserService.shared.currentUser?.id == message.fromId {
                Button {
                    showingAlertUnsend.toggle()
                } label: {
                    Label("Unsend", systemImage: "minus.circle")
                        .font(.system(size: 14))
                        .foregroundColor(currentTheme.accentColor)
                }
            }
            
            Label(message.timestampString, systemImage: "clock")
                .font(.system(size: 14))
                .foregroundColor(currentTheme.secondaryTextColor)
        }
    }
    
    private func unsendMessageText(text: String, size: CGFloat, alignment: Alignment) -> some View {
        Text(text)
            .font(.system(size: 15))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundStyle(currentTheme.secondaryTextColor)
            .overlay(
                shapeBubble
                    .stroke(currentTheme.secondaryTextColor.opacity(0.2), lineWidth: 1)
            )
            .frame(maxWidth: size, alignment: alignment)
    }
    
    private func timeMessage(size: CGFloat, alignment: Alignment) -> some View {
        Group {
            if isShowTime {
                Text(message.timestampString)
                    .font(.system(size: 12))
                    .foregroundStyle(currentTheme.secondaryTextColor)
                    .frame(maxWidth: size, alignment: alignment)
                    .padding(.vertical, 2)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    private var shapeBubble: some Shape {
        RoundedRectangle(cornerRadius: 18)
    }
}
