import SwiftUI

struct TeacherDetailView: View {
    let teacher: Teacher
    @Environment(\.dismiss) private var dismiss
    @State private var currentStyle: TeacherContactViewStyleDelegate = DefaultTeacherContactStyle()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: currentStyle.backgroundColor),
                         startPoint: .top,
                         endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(currentStyle.secondaryTextColor)
                        
                        Text(teacher.name)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(currentStyle.primaryTextColor)
                    }
                    .padding(.top, 20)
                    
                    // Theme Switcher
                    HStack(spacing: 12) {
                        ThemeButton(title: "Light", color: .orange) {
                            withAnimation(.spring()) {
                                currentStyle = DefaultTeacherContactStyle()
                            }
                        }
                        
                        ThemeButton(title: "Dark", color: .gray) {
                            withAnimation(.spring()) {
                                currentStyle = DarkTeacherContactStyle()
                            }
                        }
                        
                        ThemeButton(title: "Blue", color: .blue) {
                            withAnimation(.spring()) {
                                currentStyle = BlueTeacherContactStyle()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Contact Information Cards
                    VStack(spacing: 16) {
                        // Extension Card
                        ContactInfoCard(
                            icon: "phone.circle.fill",
                            title: "Extension",
                            value: teacher.extNo,
                            style: currentStyle
                        )
                        
                        // Contact Number Card
                        ContactInfoCard(
                            icon: "phone.fill",
                            title: "Contact Number",
                            value: teacher.contactNumber,
                            style: currentStyle,
                            action: {
                                if let url = URL(string: "tel:\(teacher.contactNumber)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        // Email Card
                        ContactInfoCard(
                            icon: "envelope.fill",
                            title: "Email",
                            value: teacher.email,
                            style: currentStyle,
                            isEmail: true,
                            action: {
                                if let url = URL(string: "mailto:\(teacher.email)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(currentStyle: currentStyle, dismiss: dismiss))
    }
}

// Helper view for contact information cards
struct ContactInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let style: TeacherContactViewStyleDelegate
    var isEmail: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(style.secondaryTextColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(style.primaryTextColor.opacity(0.7))
                    
                    Text(value)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isEmail ? style.secondaryTextColor : style.primaryTextColor)
                }
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(style.secondaryTextColor)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(style.cardBackgroundColor)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
