//
//  ContentView.swift
//  FriendsNames
//
//  Created by Arkasha Zuev on 03.08.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Friend.entity(), sortDescriptors: [])
    private var friends: FetchedResults<Friend>
    
    @State private var name = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingEditScreen = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(friends) { friend in
                        NavigationLink(destination: UserInfo(imageName: friend.imageName!, name: friend.name!).environment(\.managedObjectContext, viewContext)) {
                            HStack() {
                                if let image = loadImage(imageName: friend.imageName!) {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                }
                                VStack (alignment: .leading) {
                                    Text(friend.name!)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteFriend)
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                    self.showingEditScreen = self.inputImage != nil
                }) {
                    ImagePicker(image: self.$inputImage)
                }
                .navigationBarItems(trailing: Button(action: {
                    self.showingImagePicker = true
                }) {
                    Image(systemName: "plus")
                })
            }
            .navigationTitle(Text("Friends names"))
            .sheet(isPresented: $showingEditScreen, onDismiss: addFriend) {
                EditScreen(name: $name)
            }
        }
    }

    private func addFriend() {
        guard let uiImage = inputImage else { return }
        image = Image(uiImage: uiImage)
        let imageName = UUID().uuidString
        
        let newFriend = Friend(context: viewContext)
        newFriend.name = name
        newFriend.imageName = imageName
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        do {
            try viewContext.save()
            if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath, options: .atomic)
            }
            name = ""
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteFriend(offsets: IndexSet) {
        withAnimation {
            offsets.map { friends[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func loadImage(imageName: String) -> Image? {
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        do {
            let data = try Data(contentsOf: imagePath)
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            print("Unable to load saved data.")
            return nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
