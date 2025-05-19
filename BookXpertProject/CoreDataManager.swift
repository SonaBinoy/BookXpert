//
//  CoreDataManager.swift
//  BookXpertProject
//
//  Created by sona on 17/05/25.
//



import Foundation
import CoreData
import UIKit
import AppIntents

class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveUser(id: String, name: String, email: String) {
        let user = User(context: context)
        user.id = id
        user.name = name
        user.email = email
        saveContext()
    }

    func saveItem(id: String, name: String, data: String) {
        let item = Item(context: context)
        item.id = id
        item.name = name
        item.data = data
        saveContext()
    }

    func fetchItems() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func updateItem(item: Item, name: String, data: String) {
        item.name = name
        item.data = data
        saveContext()
    }

    func deleteItem(_ item: Item) {
        let deletedDetails = "Deleted: \(item.name ?? "")"
        context.delete(item)
        saveContext()
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

