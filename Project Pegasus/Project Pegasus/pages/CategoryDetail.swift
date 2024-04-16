//
//  CategoryDetail.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 24/02/24.
//

import SwiftUI
import SwiftData

/// tipi di filtri disponibili
enum FilterType {
    case alphabetical, efficiency,date, null
}

struct CategoryDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    let categoryId: String
    @State var categoryName: String
    @State var categoryColor: Color
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    @Query var sessions : [Session]
    let category: Category?
    @State private var showingFilter = false
    @State private var selectedFilter: FilterType = .null
    @State private var showColorPicker: Bool = false
    
    /// permette di applicare il filtro selezionato, di default è impostato .null ovvero la lista di sottocategorie così come viene ottenuta da @Query
    private var filteredSessions: [Session] {
        
        switch selectedFilter {
        case .alphabetical:
            return sessions.filter{ session in session.category!.id == categoryId }.sorted(by: { $0.activity!.title < $1.activity!.title })
        case .efficiency:
            return sessions.filter{ session in session.category!.id == categoryId }.sorted(by: { $0.progress > $1.progress })
        case .date:
            return sessions.filter{ session in session.category!.id == categoryId }.sorted(by: { $0.startDate > $1.startDate })
        case .null:
            return sessions.filter{ session in session.category!.id == categoryId }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //se la possibilità di cambiare colore è attiva allora al tap dello schermo il componente si chiude
                if showColorPicker{
                    Color.clear
                        .edgesIgnoringSafeArea(.all)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showColorPicker = false
                            }
                        }
                    
                }
                VStack(alignment: .center) {
                    
                    Spacer().frame(height: 30)
                    HStack {
                        R_button()
                            .foregroundColor(.black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                                onUpdate()
                            }
                        Spacer()
                    }
                    Spacer().frame(height: 30)
                    
                    CategoryNameAndColor(categoryName: $categoryName, showColorPicker: $showColorPicker, selectedColor: $categoryColor)
                        .onSubmit {
                            onUpdate()
                        }

                    //compare solo quando la possibilità di cambiare colore della categoria è disabilitata
                    if showColorPicker == false{
                        Button(action: {
                            showingFilter = true
                        }) {
                            Text("Ordina per")
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    ScrollView(showsIndicators: false){
                        ForEach(filteredSessions){ session in
                                CategoryDetailSession(
                                    name: session.activity != nil ? session.activity!.title.uppercased() : "Nessuna sottocategoria",
                                    color: categoryColor,
                                    progress: session.progress,
                                    gradient: gradient
                                )
                        }
                        
                        VStack{
                            Spacer()
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.4), Color.clear]), startPoint: .bottom, endPoint: .top))
                                .frame(height: 150)
                                .foregroundColor(Color.blue)
                                .ignoresSafeArea()
                        }
                        .offset(y: -150)
                        
                        
                        Image("trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                            .frame(width: 30)
                            .offset(y: -100)
                        
                        
                    }
                    .padding(.top,20)
                }
                .padding(.horizontal,25)
                .background(categoryColor.edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $showingFilter) {
                    FilterSheetView(selectedFilter: $selectedFilter)
                        .presentationDetents([.height(240)])
                        .presentationBackground(Color(categoryColor))
                }
                
                VStack{
                    Spacer()
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.4), Color.clear]), startPoint: .bottom, endPoint: .top))
                        .frame(width: UIScreen.main.bounds.width, height: 150)
                        .ignoresSafeArea()
                }.ignoresSafeArea()
                
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    /// Permette di salvare le modifiche apportare alla categoria aperta dall'utente
    func onUpdate() {
        if let category{
            if category.name != categoryName{
                category.name = categoryName
            }
            if category.color != (try! categoryColor.toHex()){
                category.color = try! categoryColor.toHex()
            }
        }
    }
}


#Preview {
    
    return CategoryDetail(categoryId: "12345", categoryName: "Prova", categoryColor: .orange, category: Category(name: "Prova", color: "FFFFFF", gifName: "blue"))
}
