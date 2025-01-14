import SwiftUI

protocol TeacherContactViewStyleDelegate {
    var backgroundColor: [Color] { get }
    var primaryTextColor: Color { get }
    var secondaryTextColor: Color { get }
    var accentColor: Color { get }
    var cardBackgroundColor: Color { get }
}

struct DefaultTeacherContactStyle: TeacherContactViewStyleDelegate {
    var backgroundColor: [Color] = [Color(hex: "#F5F5F5"), Color.white]
    var primaryTextColor: Color = Color(hex: "#2C3E50")
    var secondaryTextColor: Color = Color(hex: "#E67E22")
    var accentColor: Color = Color(hex: "#FFBB88")
    var cardBackgroundColor: Color = .white
}

struct DarkTeacherContactStyle: TeacherContactViewStyleDelegate {
    var backgroundColor: [Color] = [Color(hex: "#1A1A1A"), Color(hex: "#2D2D2D")]
    var primaryTextColor: Color = .white
    var secondaryTextColor: Color = Color(hex: "#FF9F1C")
    var accentColor: Color = Color(hex: "#FF9F1C")
    var cardBackgroundColor: Color = Color(hex: "#333333")
}

struct BlueTeacherContactStyle: TeacherContactViewStyleDelegate {
    var backgroundColor: [Color] = [Color(hex: "#E3F2FD"), Color(hex: "#BBDEFB")]
    var primaryTextColor: Color = Color(hex: "#1976D2")
    var secondaryTextColor: Color = Color(hex: "#2196F3")
    var accentColor: Color = Color(hex: "#64B5F6")
    var cardBackgroundColor: Color = .white
}

struct ModernCardStyle: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
    }
}

struct TeacherContactView: View {
    @State private var teachers: [Teacher] = []
    @State private var labs: [Lab] = []
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStyle: TeacherContactViewStyleDelegate = DefaultTeacherContactStyle()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: currentStyle.backgroundColor),
                             startPoint: .top,
                             endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header Section with Theme Switcher
                    VStack(spacing: 16) {
                        Text("CSE Department")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(currentStyle.primaryTextColor)
                            .padding(.top, 30)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        
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
                    }
                    .modifier(ModernCardStyle(backgroundColor: currentStyle.cardBackgroundColor.opacity(0.5)))
                    .padding(.horizontal, 16)
                    
                    // Content List
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 20) {
                                // Teachers Section
                                VStack(alignment: .leading, spacing: 16) {
                                    SectionHeader(icon: "person.2.fill", title: "Teachers", style: currentStyle)
                                    
                                    ForEach(teachers) { teacher in
                                        NavigationLink(destination: TeacherDetailView(teacher: teacher)) {
                                            ListItemRow(
                                                icon: "person.circle.fill",
                                                title: teacher.name,
                                                style: currentStyle
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                // Labs Section
                                VStack(alignment: .leading, spacing: 16) {
                                    SectionHeader(icon: "laptopcomputer", title: "Labs", style: currentStyle)
                                    
                                    ForEach(labs) { lab in
                                        NavigationLink(destination: LabDetailView(lab: lab)) {
                                            ListItemRow(
                                                icon: "desktopcomputer",
                                                title: lab.name,
                                                style: currentStyle
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .frame(width: geometry.size.width)
                        }
                    }
                }
                .onAppear {
                    loadData()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(currentStyle: currentStyle, dismiss: dismiss))
        }
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(TeacherContactData.self, from: data)
                
                teachers = decodedData.teachers
                labs = decodedData.labs
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}

// New helper views for better organization and reusability
struct SectionHeader: View {
    let icon: String
    let title: String
    let style: TeacherContactViewStyleDelegate
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(style.secondaryTextColor)
            Text(title)
                .font(.title2.bold())
                .foregroundColor(style.primaryTextColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.accentColor.opacity(0.2))
        )
    }
}

struct ListItemRow: View {
    let icon: String
    let title: String
    let style: TeacherContactViewStyleDelegate
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(style.secondaryTextColor)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(style.primaryTextColor)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(style.secondaryTextColor)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

struct ThemeButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
    }
}

struct BackButton: View {
    let currentStyle: TeacherContactViewStyleDelegate
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(currentStyle.secondaryTextColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(currentStyle.accentColor.opacity(0.2))
            )
        }
    }
}

