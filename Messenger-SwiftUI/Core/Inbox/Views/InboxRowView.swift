import SwiftUI
import Firebase

struct InboxRowView: View {
    @State private var isAppeared = false
    
    let message: Message
    
    var unread: Bool{
        return UserService.shared.currentUser?.id != message.fromId && message.unread
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: message.user, size: .medium)
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(message.user?.fullname ?? "")")
                        .foregroundStyle(.text)
                        .font(unread ? .bold(size: 15) : .medium(size: 15))
                    
                    if unread {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
                
                messageView
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                timeMessage
                
                if message.fromId == UserService.shared.currentUser?.id {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.gray.opacity(0.6))
                        .font(.caption2)
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 75)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .opacity(unread ? 1 : 0)
        )
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -50)
        .onAppear {
            withAnimation(.spring(duration: 0.4)) {
                isAppeared = true
            }
        }
        .scrollTransition(topLeading: .interactive,bottomTrailing: .interactive){ content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                .blur(radius: phase.isIdentity ? 0 : 10)
        }
    }
}

extension InboxRowView{
    
    private var messageView: some View{
        VStack{
            if message.isRecalled{
                HStack(spacing: 4) {
                    Image(systemName: "arrow.uturn.backward")
                        .imageScale(.small)
                        .foregroundStyle(.gray)
                    
                    Text("\(message.fromId == UserService.shared.currentUser?.id ? "You" : "\(message.user?.firstName ?? "")") unsend a message")
                        .foregroundStyle(unread ? .text : .gray)
                        .font(unread ? .bold(size: 14) : .regular(size: 14))
                        .lineLimit(1)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }else{
                Text("\(message.fromId == UserService.shared.currentUser?.id ? "You: " : "")\(message.messageText)")
                    .foregroundStyle(unread ? .text : .gray)
                    .font(unread ? .bold(size: 14) : .regular(size: 14))
                    .lineLimit(1)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
        }
    }
    
    private var timeMessage: some View{
        HStack(spacing: 4) {
            Text("\(message.timestampString)")
                .foregroundStyle(unread ? .text : .gray)
                .font(.caption)
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(unread ? .text : .gray)
        }
    }
}
