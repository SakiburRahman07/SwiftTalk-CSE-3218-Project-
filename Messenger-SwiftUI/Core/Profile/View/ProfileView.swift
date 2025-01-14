import SwiftUI
import PhotosUI

struct ProfileView: View {
    enum FocusedField {
        case newName
    }
    
    @EnvironmentObject var coordinator: Coordinator
    @Bindable var viewModel = ProfileViewModel()
    @FocusState private var focusedField: FocusedField?
    
    @State var isShowDarkMode = false
    @State private var showingAlertDeleteAccount = false
    @State private var showingLogout = false
    @State private var showingChangeName = false
    
    private var user: User? {
        return UserService.shared.currentUser ?? nil
    }
    
    var body: some View {
        VStack {
            if isShowDarkMode {
                ChangeDarkLightView(isShowDarkMode: $isShowDarkMode)
                    .transition(.move(edge: .trailing))
            } else {
                VStack(spacing: 0) {
                    // header
                    header
                        .padding(.bottom, 20)
                    
                    // list
                    List {
                        Section {
                            ForEach(SettingOptionsViewModel.allCases) { option in
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(option.imageBackgroundColor.opacity(0.15))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: option.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(option.imageBackgroundColor)
                                    }
                                    
                                    Text(option.title)
                                        .foregroundStyle(.text)
                                        .font(.regular(size: 16))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray.opacity(0.5))
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    optionOntap(option: option)
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        
                        Section {
                            logout
                            deleteAccount
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                .transition(.move(edge: .leading))
                .opacity(isShowDarkMode ? 0 : 1)
                .overlay {
                    LoadingView(show: $viewModel.isLoading)
                }
            }
        }
    }
    
    func optionOntap(option: SettingOptionsViewModel){
        switch option{
        case .darkMode:
            withAnimation {
                isShowDarkMode.toggle()
            }
        case .activeStatus:
            Alerter.shared.alert = Alert(title: Text("This feature is being updated in the future"), dismissButton: .default(Text("OK")))
        case .accessibility:
            Alerter.shared.alert = Alert(title: Text("This feature is being updated in the future"))
        case .privacy:
            Alerter.shared.alert = Alert(title: Text("This feature is being updated in the future"))
        case .notifications:
            coordinator.push(.notificationSettingView)
        }
    }
}

#Preview {
    ProfileView()
}

extension ProfileView{
    private var header: some View{
        VStack(spacing: 24) {
            HStack {
                Button {
                    coordinator.pop()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .imageScale(.medium)
                            .foregroundStyle(.text)
                        
                        Text("Back")
                            .font(.semibold(size: 16))
                            .foregroundStyle(.text)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                if viewModel.profileImage != nil {
                    Button {
                        // viewModel.upLoadAvatar()
                    } label: {
                        Text("Save")
                            .font(.semibold(size: 16))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            
            avatar
        }
    }
    
    private var avatar: some View{
        VStack(spacing: 16) {
            PhotosPicker(selection: $viewModel.selectedItem) {
                VStack {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                    } else {
                        CircularProfileImageView(user: user, size: .xxLarge)
                            .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                }
                .overlay {
                    ZStack(alignment: .bottomTrailing) {
                        Color.clear
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(.white)
                            }
                            .offset(x: 6, y: 6)
                    }
                }
            }
            
            name
        }
    }
    
    private var name: some View{
        HStack(spacing: 10) {
            if showingChangeName {
                HStack {
                    TextField("Name", text: $viewModel.nameChange)
                        .keyboardType(.default)
                        .textContentType(.name)
                        .foregroundStyle(.text)
                        .focused($focusedField, equals: .newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 160)
                    
                    Button {
                        Task {
                            try await viewModel.changeNameUser()
                            withAnimation {
                                focusedField = nil
                                showingChangeName.toggle()
                            }
                        }
                    } label: {
                        Text("Save")
                            .font(.semibold(size: 14))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            } else {
                Text(user?.fullname ?? "")
                    .font(.semibold(size: 24))
                    .foregroundStyle(.text)
                
                Button {
                    withAnimation {
                        showingChangeName.toggle()
                        focusedField = .newName
                    }
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    private var logout: some View{
        Button {
            showingLogout.toggle()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.red)
                Text("Log out")
                    .font(.regular(size: 16))
                    .foregroundStyle(.red)
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .alert(isPresented: $showingLogout) {
            Alert(
                title: Text("Confirm logout"),
                message: Text("Are you sure want to sign out?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Logout")) {
                    AuthService.shared.signOut()
                    coordinator.pop()
                }
            )
        }
    }
    
    private var deleteAccount: some View{
        Button {
            showingAlertDeleteAccount.toggle()
        } label: {
            HStack {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                Text("Delete account")
                    .font(.regular(size: 16))
                    .foregroundStyle(.red)
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .alert(isPresented: $showingAlertDeleteAccount) {
            Alert(
                title: Text("Confirm account deletion"),
                message: Text("Once your account is deleted, you will not be able to restore it. Are you sure you want to delete it?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete")) {
                    Task {
                        try await AuthService.shared.deleteUserData()
                        coordinator.pop()
                    }
                }
            )
        }
    }
}
