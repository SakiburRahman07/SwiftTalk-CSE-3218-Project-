//
//  ProfileViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI
import Firebase

@Observable
class ProfileViewModel {
    var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    var profileImage: UIImage? = UIImage(named: "img-default") // Use dummy image from assets
    var isLoading = false
    var nameChange = ""

    // Load image from picker or use the dummy image as a fallback
    func loadImage() async throws {
        guard let item = selectedItem else {
            self.profileImage = UIImage(named: "img-default")
            return
        }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else {
            self.profileImage = UIImage(named: "img-default")
            return
        }
        
        guard let uiImage = UIImage(data: data) else {
            self.profileImage = UIImage(named: "img-default")
            return
        }
        
        self.profileImage = uiImage
    }
    
    // Change user name in Firestore
    func changeNameUser() async throws {
        let userID = Auth.auth().currentUser?.uid
        
        if let userID {
            if nameChange.isEmpty {
                LocalNotification.shared.message("Please enter a new name", .warning)
            } else {
                let userRef = FirestoreContants.userCollection.document(userID)
                let dataToUpdate: [String: Any] = [
                    "fullname": nameChange
                ]
                try await userRef.setData(dataToUpdate, merge: true)
                try await UserService.shared.fetchCurrentUser()
                
                self.nameChange = ""
            }
        }
    }
}
