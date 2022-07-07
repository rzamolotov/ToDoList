//
//  ContentView.swift
//  ToDo
//
//  Created by Роман Замолотов on 04.07.2022.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: ToDo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDo.name, ascending: true)]) var todos: FetchedResults<ToDo>
    
    @State private var showingAddTodoView: Bool = false // значение кнопки добавить задачу по умолчанию
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.todos, id: \.self) { todo in
                    HStack {
                        Text(todo.name ?? "Unknow")
                        
                        Spacer()
                        
                        Text(todo.priority ?? "Unknow")
                    }
                    
                }// END: - ForeEach
                .onDelete(perform: deleteTodo) //тут добавляем функцию удаления задачи
            }// END: - List
            .navigationBarTitle("Список задач", displayMode: .large)
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                self.showingAddTodoView.toggle()
            }) {
                Image(systemName: "plus")
            }) // END: - Add Button
            
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
        }// END: - Navigation
    }
    // MARK: - Nvigation
    
    private func deleteTodo(at offsets: IndexSet) { //описание функции удаления
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo) // удаляем конкртную задачу
            
            do {
                try managedObjectContext.save()
            } catch {
                print (error)
            }
        }
    }
}

// MARK: - Prieview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
