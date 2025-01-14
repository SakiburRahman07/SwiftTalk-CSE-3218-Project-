import SwiftUI

struct LabDetailView: View {
    let lab: Lab
    
    var body: some View {
        ScrollView {
            VStack {
                Text(lab.name)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                VStack(spacing: 15) {
                    Text("Room Number: \(lab.roomNumber)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Extension: \(lab.extNo)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Related Person: \(lab.relatedPerson)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
            .navigationTitle("Lab Details")
        }
    }
}
