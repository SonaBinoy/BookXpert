//
//  HomeViewController.swift
//  BookXpertProject
//
//  Created by sona on 17/05/25.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate{
  
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!

        var items: [Item] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            loadItems()
            tableView.dataSource = self
            tableView.delegate = self
            notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "notifications_enabled")
            NotificationManager.shared.requestPermission()
            UNUserNotificationCenter.current().delegate = self



        }
    
    @IBAction func openPDFTapped(_ sender: Any) {
        performSegue(withIdentifier: "showPDF", sender: self)
    }
    
    @IBAction func openImageTapped(_ sender: Any) {
        performSegue(withIdentifier: "imageShow", sender: self)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: Any) {
        UserDefaults.standard.set((sender as AnyObject).isOn, forKey: "notifications_enabled")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

            completionHandler([.banner, .sound])
        }
    
    
    
        func loadItems() {
            APIManager.shared.fetchData { models in
                guard let models = models else { return }
                DispatchQueue.main.async {
                    models.forEach { model in
                        let dataString = model.data?.map { "\($0.key): \($0.value)" }.joined(separator: ", ") ?? ""
                        CoreDataManager.shared.saveItem(id: model.id, name: model.name, data: dataString)
                    }
                    self.items = CoreDataManager.shared.fetchItems()
                    self.tableView.reloadData()
                }
            }
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name

        if let dataDict = item.data as? [String: CodableValue] {
            let dataString = dataDict.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            cell.detailTextLabel?.text = dataString
        } else {
            cell.detailTextLabel?.text = "No details"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            CoreDataManager.shared.deleteItem(item)
            NotificationManager.shared.sendDeletedItemNotification(itemName: item.name ?? "Unknown", itemData: item.data ?? "")
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    }
