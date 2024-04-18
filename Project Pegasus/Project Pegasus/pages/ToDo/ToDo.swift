//
//  ToDo.swift
//  Project Pegasus
//
//  Created by Hasan on 14/04/2024.
//

import SwiftUI
import SwiftData

struct ToDo: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    @State var isPresented = false
    @State var viewSessions = false
    @Query var categories: [Category] = []
    @Query var activities: [Activity]
    @Query var sessions: [Session]
    @State private var selectedItem = 0
    @StateObject var toDoVM = ToDoViewModel()
    @FocusState var dateFocused: Bool
    @FocusState var nameFocused: Bool
    @AppStorage("displayMode") var displayMode: String = "system"
    //  @FocusState var Focused = false
    var body: some View {
        NavigationStack{
            ZStack {
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer().frame(height: 10)
                    HStack {
                        Button {
                            
                        } label: {
                            Image(.graph)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 28.5, height: 19)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        Spacer()
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        
                    }
                    Spacer().frame(height: 30)
                    HStack{
                        
                        Text("TO DO LIST")
                            .font(Font.custom("Montserrat", size: 36).weight(.bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                        
                        Button {
                            viewSessions = false
                        } label: {
                            Image(.checkmark2)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 25)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .opacity(viewSessions ? 1 : 0)
                        }
                        
                    }
                    
                    if viewSessions{
                        TabView(selection: $selectedItem) {
                            ForEach(categories){category in
                                VStack(alignment:.leading){
                                    Text(category.name.uppercased())
                                        .font(Font.custom("Montserrat", size: 24).weight(.bold))
                                        .foregroundColor(Color(hex: category.color))
                                        .padding(.bottom,12)
                                    
                                    VStack(alignment:.leading,spacing: 13){
                                        
                                        ScrollView {
                                            if toDoVM.addSubCategory{
                                                HStack{
                                                    
                                                    CircularProgressView(progress: 0.8, color: Color.init(hex: category.color))
                                                        .frame(width:16.5,height:16.5)
                                                    
                                                    TextField(text: $toDoVM.newActivityName, prompt: Text("Home sessione")) {
                                                        
                                                    }
                                                    .font(Font.custom("Montserrat", size: 15))
                                                    .keyboardType(.alphabet)
                                                    .focused($nameFocused)
                                                    
                                                    Spacer()
                                                    
                                                    TextField(text: $toDoVM.newDateString, prompt: Text("00/00")) {
                                                        
                                                    }
                                                    .keyboardType(.numberPad)
                                                    .font(Font.custom("Montserrat", size: 15).weight(.bold))
                                                    .frame(width:48)
                                                    .focused($dateFocused)
                                                    
                                                }
                                            }
                                            ForEach(activities.filter({$0.category.id == category.id})){activity in
                                                HStack{
                                                    if toDoVM.isDeleting{
                                                        Button {
                                                            if toDoVM.deletedActivities.contains(where: {$0.id == activity.id}){
                                                                toDoVM.deletedActivities.removeAll(where: {$0.id == activity.id})
                                                            }
                                                            else{
                                                                toDoVM.deletedActivities.append(activity)
                                                            }
                                                        } label: {
                                                            if toDoVM.deletedActivities.contains(where: {$0.id == activity.id}){
                                                                Circle()
                                                                    .fill(Color(hex: categories[selectedItem].color).opacity(0.7))
                                                                    .stroke(Color(hex: categories[selectedItem].color))
                                                                    .frame(width: 22, height: 22)
                                                            }
                                                            else{
                                                                Circle()
                                                                    .stroke(Color(hex: categories[selectedItem].color))
                                                                    .frame(width: 22, height: 22)
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                    else{
                                                        CircularProgressView(progress: toDoVM.getRecentSessionProgress(sessions:sessions, activityId: activity.id) ?? 0, color: Color(hex: categories[selectedItem].color))
                                                            .frame(width: 18, height: 18)
                                                    }
                                                    Text(activity.title)
                                                        .font(Font.custom("HelveticaNeue", size: 16))
                                                        .frame(height: 22)
                                                    //.padding(.vertical,8)
                                                    Spacer()
                                                    Text("\(activity.day)/\(activity.month)")
                                                        .font(Font.custom("Montserrat", size: 15).weight(.bold))
                                                        .foregroundColor(Color(hex: category.color))
                                                }
                                                .onLongPressGesture(perform: {
                                                    toDoVM.isDeleting = true
                                                    toDoVM.addSubCategory = false
                                                })
                                                
                                            }
                                        }
                                        .frame(height: 92)
                                        
                                        HStack(spacing:12) {
                                            Button {
                                                toDoVM.addSubCategory = true
                                                toDoVM.isDeleting = false
                                            } label: {
                                                HStack{
                                                    ZStack(alignment:.center){
                                                        Circle()
                                                            .stroke(Color.init(uiColor: .label))
                                                            .frame(width: 22, height: 22)
                                                        Image(systemName: "plus")
                                                            .resizable()
                                                            .frame(width: 12, height: 12)
                                                        //.font(Font.custom("HelveticaNeue", size: 20))
                                                    }
                                                    
                                                    Text("Attivitá")
                                                }
                                                .foregroundColor(Color.init(uiColor: .label))
                                            }
                                            Spacer()
                                            Button {
                                                if toDoVM.isDeleting{
                                                    toDoVM.deletedSelectedActivites(context: context)
                                                }
                                            } label: {
                                                Image(.bin)
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(Color(hex: toDoVM.isDeleting ? category.color : "#59574C"))
                                                    .frame(width: 25, height: 25)
                                            }
                                            
                                        }
                                        .font(Font.custom("HelveticaNeue", size: 16))
                                        .frame(height:25)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .tag(categories.firstIndex(of: category) ?? 0)
                                
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height:240)
                        .background(LinearGradient(colors: [Color(hex: categories[selectedItem].color).opacity(0.3), Color(hex: categories[selectedItem].color).opacity(0.8)], startPoint: .leading, endPoint: .trailing).cornerRadius(10)
                                    
                        )
                    }
                    
                    else{
                        Button {
                            viewSessions = true
                        } label: {
                            ZStack {
                                Image(.toDoBackground)
                                    .resizable()
                                ScrollView {
                                    ForEach(sessions.filter({!$0.isCompleted && $0.progress < 1})){session in
                                        VStack{
                                            HStack{
                                                Text(session.activity?.title ?? session.category?.name ?? "")
                                                Spacer()
                                                Text("\(Int(session.progress * 100))%")
                                            }
                                            ZStack{
                                                GeometryReader { proxy in
                                                    Rectangle().fill(Color("Divider")).frame(height:1.5)
                                                        .padding(.top,0.75)
                                                    Rectangle().fill(Color.init(hex: session.category?.color ?? "#FFFFFF")).frame(width: proxy.size.width * session.progress, height:3)
                                                    
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .frame(height:124)
                        }
                       
                    }
            
                    Color.init(uiColor: .label)
                        .frame(height:1)
                        .padding(.top,22)
                    HStack{
                        Text("ROUND DI GRUPPO")
                            .font(Font.custom("Montserrat", size: 24).weight(.bold))
                            .foregroundColor(Color.init(uiColor: .label))
                            
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(.classroom)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 30, height: 30)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    .padding(.top,7)
                        
                    Color.init(uiColor: .label)
                        .frame(height:1)
                        .padding(.top,22)
                    
                    
                    HStack{
                        Text("TEMA")
                            .font(Font.custom("Montserrat", size: 24).weight(.bold))
                            .foregroundColor(Color.init(uiColor: .label))
                        
                        Button {
                            displayMode = "light"
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .stroke(Color.black.opacity(displayMode == "light" ? 1 : 0))
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                        }

                        Button {
                            displayMode = "dark"
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.black)
                                .stroke(Color.white.opacity(colorScheme == .dark ? 1 : 0))
                                .stroke(Color.black.opacity(colorScheme == .light ? 1 : 0))
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                        }
                        
                        Button {
                            displayMode = "system"
                        } label: {
                            Text("A")
                                .foregroundColor(.init(uiColor: .label))
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.init(uiColor: .systemBackground))
                                        .stroke(Color.init(uiColor: .label).opacity(displayMode == "system" ? 1 : 0))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(5)
                                )
                        }
                        .padding(.horizontal,8)
                        Spacer()
                      
                    }
                    
                    Spacer()
                }
                .padding(.horizontal,32)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
            .background(Color.clear)
            .onTapGesture {
                nameFocused = false
                dateFocused = false
            }
        }
        .onChange(of: toDoVM.newDateString, initial: false, {
            toDoVM.formatDate()
        })
        .onChange(of: nameFocused, { oldValue, newValue in
            if !newValue{
                toDoVM.createActivityIfNeeded(context:context, category: categories[selectedItem])
            }
        })
        .onChange(of: dateFocused, { oldValue, newValue in
            if !newValue{
                toDoVM.createActivityIfNeeded(context:context, category: categories[selectedItem])
            }
        })
        
    }
    
}
#Preview {
    ToDo()
}
