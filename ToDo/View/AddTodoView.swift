//
//  AddTodoView.swift
//  ToDo
//
//  Created by Роман Замолотов on 04.07.2022.
//

import SwiftUI

struct AddTodoView: View {
// MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = "" // задача по умолчанию
    @State private var priority: String = "Обычный" // устанавливаем стандартный приоритет
    
    let priorities = ["Высокий", "Обычный", "Низкий"] // устанавливаем виды приоритетов заданиям
    
    @State private var errorShoving: Bool = false
    @State private var errorTitle: String = " "
    @State private var errorMessage: String = " "

// MARK: - BODY
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Введите новую задачу", text: $name)
                    
                    // MARK: - TODO PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())// внешний вид переключателя задач
                    
                    //  MARK: - SAVE BUTTON
                    Button(action: {
                      if self.name != "" {
                    
                     let todo = ToDo(context: self.managedObjectContext)
                        todo.name = self.name
                        todo.priority = self.priority
                        
                        do {
                          try self.managedObjectContext.save()
                        print("New todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                        } catch {
                          print(error)
                        }
                      } else {
                        self.errorShoving = true
                        self.errorTitle = "Некорректное имя задачи"
                        self.errorMessage = "Убедитесь, что вы ввели задачу"
                        return
                      }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                      Text("Сохранить")
                    }// END: - Save Button
                } // END: FORM
                    
                Spacer()
                
            } // END: VStack
            .navigationBarTitle("Новая задача", displayMode: .inline)// делаем заголовок приложенияы
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }
            )
            .alert(isPresented: $errorShoving) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Понятно")))
            }
        } // END: Navigation
    }
}

// MARK: - PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
