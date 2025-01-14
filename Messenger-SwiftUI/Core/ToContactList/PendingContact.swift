import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PendingContactView: View {
    @Environment(\.dismiss) private var dismiss // Environment action for back button
    @State private var todos: [ToDo] = []
    @State private var newTaskName: String = ""
    @State private var errorMessage: String?
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Text("Your To-Contact List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()

                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .cornerRadius(20)
                            .shadow(radius: 10)

                        List {
                            ForEach($todos) { $todo in
                                VStack(alignment: .leading, spacing: 10) {
                                    if todo.isEditing {
                                        HStack {
                                            TextField("Edit Task", text: $todo.title)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .foregroundColor(.black)

                                            Button(action: {
                                                updateTask(todo: todo)
                                                todo.isEditing = false
                                            }) {
                                                Text("Save")
                                                    .font(.caption)
                                                    .padding(5)
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(5)
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Text("💬 \(todo.title)")
                                                .font(.headline)

                                            Spacer()

                                            Button(action: {
                                                todo.isEditing.toggle()
                                            }) {
                                                Text("Edit ✏")
                                                    .font(.caption)
                                                    .padding(5)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(5)
                                            }

                                            Button(action: {
                                                deleteTask(todo: todo)
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                    }

                                    Text("📅 Added: \(todo.dateFormatted)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .background(Color.clear)
                        .cornerRadius(20)
                    }
                    .padding()

                    VStack {
                        TextField("Enter New Task 📋", text: $newTaskName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)

                        Button(action: {
                            if !newTaskName.isEmpty {
                                addTask(title: newTaskName)
                            }
                        }) {
                            Text("Add ➕")
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    fetchTasks()
                }
            }
            .navigationTitle("Pending Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Dismiss the current view
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                            .padding(5)
                    }
                }
            }
        }
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

    private func addTask(title: String) {
        guard let userID = currentUserID else {
            errorMessage = "Unable to add task: No user logged in."
            return
        }

        let db = Firestore.firestore()
        let newTask = [
            "Title": title,
            "DateAdded": Timestamp(),
            "userID": userID
        ] as [String: Any]

        db.collection("ToDos").addDocument(data: newTask) { error in
            if let error = error {
                print("Error adding task: \(error.localizedDescription)")
            } else {
                newTaskName = ""
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
        db.collection("ToDos").document(todo.id).updateData(["Title": todo.title]) { error in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
            } else {
                print("Task updated to \(todo.title)")
            }
        }
    }
}

struct ToDo: Identifiable {
    var id: String
    var title: String
    var dateAdded: Date
    var isEditing: Bool = false

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["Title"] as? String ?? "Untitled Task"
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
