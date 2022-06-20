//
//  BarcodeCreator.swift
//  BarcodeApp
//
//  Created by Abdullah Kardas on 17.06.2022.
//

import SwiftUI
import CarBode
import UIKit

class BarcodeCreaterViewModel:ObservableObject {
    
    func saveImage(imageName: String, image: UIImage) {


     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }



    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
}

struct BarcodeGenerator: View {
    
    @State var dataString = "This is example barcode"
    @State var barcodeType = CBBarcodeView.BarcodeType.qrCode
    @State var rotate = CBBarcodeView.Orientation.up
    @StateObject var vm = BarcodeCreaterViewModel()
    @State var image:UIImage = UIImage()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("SplashBack").ignoresSafeArea()
                VStack(spacing:45){
                    CBBarcodeView(data: $dataString,
                                                  barcodeType: $barcodeType,
                                  orientation: $rotate, onGenerated: {value in
                        guard let value = value else {return}
                        image = value
                        
                    }).frame(width: 200, height: 200).cornerRadius(8).onTapGesture {
                        vm.saveImage(imageName: "example", image: image)
                    }
                   
                    TextField("Enter something", text: $dataString).padding(12).background {
                        Capsule(style: .circular).fill(.gray.opacity(0.3))
                    }.foregroundColor(.white).padding()
                }
            }.navigationBarHidden(true).navigationBarBackButtonHidden(false)
        }
    }
}

struct BarcodeCreator_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeGenerator()
    }
}
