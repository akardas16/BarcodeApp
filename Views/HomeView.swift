//
//  HomeView.swift
//  BarcodeApp
//
//  Created by Abdullah Kardas on 17.06.2022.
//

import SwiftUI
import CarBode
import AVFoundation
import AlertToast

struct BarcodeGenerator: View {
    @State var showToast:Bool = false
    @State var value:String = ""
    
    @State var dataString = "Hello Carbode"
    @State var barcodeType = CBBarcodeView.BarcodeType.qrCode
    @State var rotate = CBBarcodeView.Orientation.up
    var body: some View {
        VStack {
            CBBarcodeView(data: $dataString,
                                          barcodeType: $barcodeType,
                          orientation: $rotate, onGenerated: {_ in }).frame(width: 200, height: 200)
            CBScanner(supportBarcode: .constant([.qr,.code128]),
                      torchLightIsOn: .constant(true),
                      scanInterval: .constant(5.0),
                      cameraPosition: .constant(.back), mockBarCode: .constant(BarcodeData(value:"Mocking data", type: .qr)),
                      isActive: true,
                      onFound: {print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                value = $0.value
                showToast.toggle()
            },
                      onDraw: {
                print("Preview View Size = \($0.cameraPreviewView.bounds)")
                                print("Barcode Corners = \($0.corners)")

                                //line width
                                let lineWidth = 1

                                //line color
                                let lineColor = UIColor.red

                                //Fill color with opacity
                                //You also can use UIColor.clear if you don't want to draw fill color
                                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)

                                //Draw box
                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
            }).frame(width: 200, height: 200).cornerRadius(16)
        }.toast(isPresenting: $showToast) {
            AlertToast(displayMode: .hud, type: .regular, title: "Result", subTitle: value)
            //AlertToast(displayMode: .alert, type: .regular, title: value)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       BarcodeGenerator()
    }
}
