//
//  Profile.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/11/23.
//

import SwiftUI
import SwiftData

struct Profile: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    @Query var users: [User]
    @Query var categories: [Category]
    @State private var isSheetPresented: Bool = false
    @Query var sessions: [Session]
    
    
    private func daysSelected() -> String? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateIntervals = [-2, -1, 0, 1, 2]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let dates = dateIntervals.map { daysOffset in
            calendar.date(byAdding: .day, value: daysOffset, to: today)!
        }
        
        let formattedDates = dates.map { dateFormatter.string(from: $0) }
        
        if let firstDate = formattedDates.first, let lastDate = formattedDates.last {
            let resultString = "\(firstDate) - \(lastDate)"
            return resultString // Ritorna la stringa dell'intervallo di date.
        }
        
        return nil // Ritorna nil se non è possibile calcolare l'intervallo.
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack{
                    
                    colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer().frame(height: 10)
                        HStack {
                            R_button()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .onTapGesture {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            Spacer()
                        }.padding(.leading)
                        
                        Spacer().frame(height: 30)
                        
                        
                        AIAnalysis()
                        /*
                        Text("Categorie".uppercased())
                            .font(Font.custom("Montserrat", size: 32).weight(.bold))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding([.leading])
                            .frame(height: 33)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        ScrollView{
                            ForEach(categories) { category in
                                // al click della categoria vai alla pagina dettaglio categoria
                                NavigationLink(destination: CategoryDetail(categoryId: category.id ,categoryName: category.name.uppercased(), categoryColor: Color(hex: colorScheme == .dark ? category.color : category.darkColor), category: category)) {
                                    CategoryWStats(
                                        name: category.name.uppercased(),
                                        color: Color(hex: colorScheme == .dark ? category.color : category.darkColor),
                                        progress: category.progress
                                    )
                                    .frame(maxWidth: UIScreen.main.bounds.size.width*0.85)
                                    .padding(5)
                                }
                            }
                        }
                        
                        Spacer()
                        /*
                         Text("+ Nuovo Tag")
                         .font(Font.custom("HelveticaNeue", size: 24))
                         .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                         .padding()
                         .onTapGesture {
                         isSheetPresented = true
                         }*/
                        NavigationLink(destination: AddNewCategory()) {
                            Text("+ Nuovo Tag")
                                .font(Font.custom("HelveticaNeue", size: 24))
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                                .padding()
                        }
                        */
                        CalendarScreen(calendar: Calendar(identifier: .gregorian))
                    }
                }
            }
        }
        .background(.black)
        .foregroundColor(.white)
        .sheet(isPresented: $isSheetPresented, onDismiss: {isSheetPresented = false}, content: {
            AddCategory(isPresented: $isSheetPresented).background(.black)
        })
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}



#Preview {
    return Profile()
}
