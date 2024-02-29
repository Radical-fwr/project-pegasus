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
    let categoryId: String
    let categoryName: String
    let categoryColor: Color!
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    @Query var sessions : [Session]
    @State private var showingFilter = false
    @State private var selectedFilter: FilterType = .null
    
    /// permette di applicare il filtro selezionato, di default è impostato .null ovvero la lista di sottocategorie così come viene ottenuta da @Query
    private var filteredSessions: [Session] {
        
        switch selectedFilter {
        case .alphabetical:
            return sessions.filter{ session in session.category!.id == categoryId }.sorted(by: { $0.subCategory!.name < $1.subCategory!.name })
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
                VStack(alignment: .center) {
                    
                    Spacer().frame(height: 30)
                    HStack {
                        R_button()
                            .foregroundColor(.black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    Spacer().frame(height: 30)
                    
                    HStack {
                        Text(categoryName)
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        
                        Spacer()
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 3)
                            .frame(width: 28, height: 28)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Button(action: {
                        showingFilter = true
                    }) {
                        Text("Ordina per")
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    
                    ScrollView(showsIndicators: false){
                        
                        /// codice di test
    //                    ForEach(0..<15) { _ in
    //                        CategoryWStats(
    //                            name: "Analisi 2",
    //                            color: categoryColor,
    //                            progress: 0.6,
    //                            gradient: gradient
    //                        )
    //                    }
                        
                        ForEach(filteredSessions){ session in
                                CategoryDetailSession(
                                    name: session.subCategory != nil ? session.subCategory!.name.uppercased() : "Nessuna sottocategoria",
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
}


#Preview {
    
    return CategoryDetail(categoryId: "12345", categoryName: "Prova", categoryColor: .orange)
}
