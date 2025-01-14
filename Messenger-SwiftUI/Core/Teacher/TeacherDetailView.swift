import SwiftUI

struct TeacherDetailView: View {
    let teacher: Teacher
    
    var body: some View {
        ScrollView {
            VStack {
                Text(teacher.name)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                VStack(spacing: 15) {
                    Text("Extension: \(teacher.extNo)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Contact Number: \(teacher.contactNumber)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Email: \(teacher.email)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let url = URL(string: "mailto:\(teacher.email)") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#F5F5F5"))
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Teacher Details")
        }
    }
}
