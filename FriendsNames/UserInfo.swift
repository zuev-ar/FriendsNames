//
//  UserInfo.swift
//  FriendsNames
//
//  Created by Arkasha Zuev on 10.08.2021.
//

import SwiftUI

struct UserInfo: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var imageName: String
    @State var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            loadImage(imageName: imageName)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Rectangle())
                .cornerRadius(10)
                .padding()
            Text(name)
                .font(.title)
        }
        
        Spacer()
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
