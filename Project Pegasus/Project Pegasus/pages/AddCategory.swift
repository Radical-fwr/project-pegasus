//
//  AddCategory.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 10/11/23.
//

import SwiftUI

struct AddCategory: View {
    @State private var color: Color = .white
    @State private var nome: String = ""
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    
    private func onSave() {
        do {
            let newCat: Category = Category(name: nome, color: try color.toHex(), gifName: "blue")
            context.insert(newCat)
            try context.save()
            isPresented = false
        } catch {
            // Handle the error here
            print("Error saving context: \(error)")
            // You might want to present an alert to the user or take other appropriate actions
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("r.")
                        .font(Font.custom("HelveticaNeue", size: 40))
                        .padding()
                    Spacer()
                    if nome.isEmpty {
                        Button("Salva") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    else {
                        Button("Salva") {
                            onSave()
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.black)
                        .tint(.white)
                    }
                    
                }
                
                Text("Nomina il tag")
                    .font(Font.custom("HelveticaNeue", size: 20))
                    .foregroundColor(.white)
                    .padding()
                
                TextField("", text: $nome, prompt: Text("Scrivi").foregroundColor(color.isLight ? .black : .white))
                    .font(Font.custom("HelveticaNeue", size: 20))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 100).fill(color))
                    .foregroundColor(color.isLight ? .black : .white)
                    .multilineTextAlignment(.center)
                
                ColorPicker("Imposta il colore", selection: $color)
                    .padding(.top)
                    .font(Font.custom("HelveticaNeue", size: 20))
                    .colorScheme(.dark)
                    .padding()
                
                Spacer()
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

extension Color {
    var isLight: Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        return brightness > 0.5
    }
}

enum ColorConversionError: Error {
    case invalidColorComponents
}

extension Color {
    func toHex() throws -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            throw ColorConversionError.invalidColorComponents
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}




