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
import UIKit

class BarcodeViewModel:ObservableObject {
    
    init() {
        sleep(1)
    }
}

struct BarcodeScanner: View {
    @StateObject var vm = BarcodeViewModel()
    @State var showToast:Bool = false
    @State var value:String = ""
    @State var barcodeAnim:Bool = false
    @State var animActive:Bool = true
    @State var torchLight:Bool = false
    @State var cameraPos:Bool = true
    @State var cameraPosition:AVCaptureDevice.Position = .back
    @State var showSheet:Bool = false
    @State var isActiveNav:Bool = false
    
   
    var body: some View {
        
            ZStack {

                Color("SplashBack").ignoresSafeArea()
                HStack(spacing: 0){
                    Spacer()
                    VStack {
                        Text(torchLight ? "Torch Light (On)" : "Torch Light (Off)").font(.headline).foregroundColor(.white)
                        Toggle(isOn: $torchLight) {
                           
                        }.labelsHidden()
                    }
                    Spacer()
                    VStack {
                        Text(cameraPos ? "Camera (Back)" : "Camera (Front)").font(.headline).foregroundColor(.white)
                        Toggle(isOn: $cameraPos) {
                            
                        }.labelsHidden().onChange(of: cameraPos) { newValue in
                            cameraPosition = newValue ? .back : .front
                    }
                    }
                    Spacer()
                }.offset(x: 0, y: -180)
                
                
                CBScanner(supportBarcode: .constant([.qr,.code128]),
                          torchLightIsOn: $torchLight,
                          scanInterval: .constant(5.0),
                          cameraPosition: $cameraPosition, mockBarCode: .constant(BarcodeData(value:"Mocking data", type: .qr)),
                          isActive: animActive,
                          onFound: {print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                   
                    value = $0.value
                    showToast.toggle()
                },
                          onDraw: {
                    animActive = true
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
                }).frame(width: 200, height: 200).cornerRadius(8)
                    .overlay(alignment: barcodeAnim ? .top : .bottom, content: {
                        ZStack{
                            Capsule(style: .circular).fill(.green).frame(maxWidth: .infinity).opacity(animActive ? 1:0).frame(height: 3).padding(.horizontal,2)
                        }
                    })
                
                Button {
                    isActiveNav.toggle()
                } label: {
                    Text("Create Barcode").foregroundColor(.white).padding().frame(width: 200).background {
                        Capsule(style: .continuous).fill(.blue.opacity(0.5))
                    }
                }.buttonStyle(btnStyle()).offset(y:200)
                NavigationLink(isActive: $isActiveNav) {
                    BarcodeGenerator()
                } label: {
                   
                }


                
                
            }.toast(isPresenting: $showToast, alert: {
                AlertToast(displayMode: .hud, type: .regular, title: "Result", subTitle: value)
            }, completion: {
                animActive = false
            })
           .onAppear(perform: {
               print("appeared")
                withAnimation(animActive ? Animation.easeInOut(duration: 0.6).repeatForever() : .none) {
                    barcodeAnim = true
                    animActive = true
                }
           }).onDisappear {
               print("disappeared")
               barcodeAnim = false
               animActive = false
           }
        
       
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       BarcodeScanner()
    }
}

struct btnStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? CGFloat(0.85) : 1.0)
            .animation(Animation.spring(response: 0.35, dampingFraction: 0.35), value: configuration.isPressed)
    }
}

