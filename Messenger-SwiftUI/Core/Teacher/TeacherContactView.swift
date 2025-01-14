import SwiftUI

struct TeacherContactView: View {
    @State private var teachers: [Teacher] = []
    @State private var labs: [Lab] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Neutral background color
                Color(hex: "#F5F5F5")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header
                    Text("CSE Department")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    // Centered list
                    GeometryReader { geometry in
                        VStack {
                            List {
                                Section(header: Text("Teachers")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.vertical, 10)
                                            .background(Color(hex: "#FFBB88").opacity(0.8))
                                            .cornerRadius(10)) {
                                    ForEach(teachers) { teacher in
                                        NavigationLink(destination: TeacherDetailView(teacher: teacher)) {
                                            HStack {
                                                Image(systemName: "person.fill")
                                                    .foregroundColor(Color(hex: "#FFBB88"))
                                                Text(teacher.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .padding(.vertical, 10)
                                            }
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
                                        }
                                    }
                                }
                                
                                Section(header: Text("Labs")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.vertical, 10)
                                            .background(Color(hex: "#FFBB88").opacity(0.8))
                                            .cornerRadius(10)) {
                                    ForEach(labs) { lab in
                                        NavigationLink(destination: LabDetailView(lab: lab)) {
                                            HStack {
                                                Image(systemName: "gearshape.fill")
                                                    .foregroundColor(Color(hex: "#FFBB88"))
                                                Text(lab.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .padding(.vertical, 10)
                                            }
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
                                        }
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.9) // Center the list
                            .listStyle(InsetGroupedListStyle())
                            .onAppear {
                                loadData()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    Text("Back")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            })
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
