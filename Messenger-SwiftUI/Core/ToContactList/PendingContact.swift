import SwiftUI
import FirebaseFirestore
import FirebaseAuth



struct PendingContactView: View {
    @Environment(\.dismiss) private var dismiss // Environment action for back button
    @State private var todos: [ToDo] = []
    @State private var newTaskName: String = ""
    @State private var newContactNumber: String = ""
    @State private var errorMessage: String?
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(hex: "4CA1AF"),
                    Color(hex: "2C3E50")
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Your To-Contact List")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        // Updated Input Section
                        VStack(spacing: 12) {
                            TextField("Enter Name/Message 📋", text: $newTaskName)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            TextField("Enter Contact Number 📞", text: $newContactNumber)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .keyboardType(.phonePad)
                            
                            Button(action: {
                                if !newTaskName.isEmpty && !newContactNumber.isEmpty {
                                    addTask(title: newTaskName, contactNumber: newContactNumber)
                                }
                            }) {
                                Text("Add Contact")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        (!newTaskName.isEmpty && !newContactNumber.isEmpty) ?
                                        Color(hex: "4CA1AF") : Color.gray
                                    )
                                    .cornerRadius(15)
                            }
                            .disabled(newTaskName.isEmpty || newContactNumber.isEmpty)
                        }
                        .padding(.horizontal)

                        // Tasks List
                        VStack(spacing: 12) {
                            ForEach($todos) { $todo in
                                TaskCard(todo: $todo, updateTask: updateTask, deleteTask: deleteTask)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear { fetchTasks() }
    }

    private func fetchTasks() {
        guard let userID = currentUserID else {
            errorMessage = "Unable to fetch tasks: No user logged in."
            return
        }

        let db = Firestore.firestore()
        db.collection("ToDos").whereField("userID", isEqualTo: userID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    return
                }

                self.todos = snapshot?.documents.map { doc in
                    ToDo(id: doc.documentID, data: doc.data())
                } ?? []
            }
    }

    private func addTask(title: String, contactNumber: String) {
        guard let userID = currentUserID else {
            errorMessage = "Unable to add task: No user logged in."
            return
        }

        let db = Firestore.firestore()
        let newTask = [
            "Title": title,
            "ContactNumber": contactNumber,
            "DateAdded": Timestamp(),
            "userID": userID
        ] as [String: Any]

        db.collection("ToDos").addDocument(data: newTask) { error in
            if let error = error {
                print("Error adding task: \(error.localizedDescription)")
            } else {
                newTaskName = ""
                newContactNumber = ""
            }
        }
    }

    private func deleteTask(todo: ToDo) {
        let db = Firestore.firestore()
        db.collection("ToDos").document(todo.id).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            } else {
                print("Task \(todo.title) deleted successfully")
            }
        }
    }

    private func updateTask(todo: ToDo) {
        let db = Firestore.firestore()
        db.collection("ToDos").document(todo.id).updateData([
            "Title": todo.title,
            "ContactNumber": todo.contactNumber
        ]) { error in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
            } else {
                print("Contact updated successfully")
            }
        }
    }
}

struct TaskCard: View {
    @Binding var todo: ToDo
    let updateTask: (ToDo) -> Void
    let deleteTask: (ToDo) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if todo.isEditing {
                VStack(spacing: 10) {
                    TextField("Edit Name/Message", text: $todo.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Edit Contact Number", text: $todo.contactNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
                    Button(action: {
                        updateTask(todo)
                        todo.isEditing = false
                    }) {
                        Text("Save Changes")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "4CA1AF"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(todo.title)
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(Color(hex: "2C3E50"))
                            
                            Text(todo.contactNumber)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                        
                            
                            Button(action: { todo.isEditing.toggle() }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(Color(hex: "4CA1AF"))
                                    .font(.title2)
                            }
                            
                            Button(action: { deleteTask(todo) }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(Color(hex: "FF3B30"))
                                    .font(.title2)
                            }
                        }
                    }
                    
                    Text("Added: \(todo.dateFormatted)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ToDo: Identifiable {
    var id: String
    var title: String
    var contactNumber: String
    var dateAdded: Date
    var isEditing: Bool = false

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["Title"] as? String ?? "Untitled Task"
        self.contactNumber = data["ContactNumber"] as? String ?? ""
        if let timestamp = data["DateAdded"] as? Timestamp {
            self.dateAdded = timestamp.dateValue()
        } else {
            self.dateAdded = Date()
        }
    }

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateAdded)
    }
}

#Preview {
    PendingContactView()
}
