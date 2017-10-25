//
//  ViewController.swift
//  Realm Tasks Tutorial
//
//  Created by iMeraj-MacbookPro on 25/10/2017.
//  Copyright © 2017 Meraj. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class ViewController: UITableViewController {
  var notificationToken: NotificationToken?
  var items = List<Task>()
  var taskList = TaskList()
  var realm: Realm!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupUI()
    setupRealm()
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  func setupRealm() {
    let username = "realm-admin"
    let password = "test"
    
    SyncUser.logIn(with: .usernamePassword(username: username, password: password), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
      guard let user = user else {
        fatalError(String(describing: error))
      }
      
      DispatchQueue.main.async {
        let configuration = Realm.Configuration(
          syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/realmtasks2")!)
        )
        self.realm = try! Realm(configuration: configuration)

        func updateList() {
          if self.realm != nil, let list = self.realm.objects(TaskList.self).first {
            self.items = list.items
          }
          self.tableView.reloadData()
        }
        updateList()
        
        // Notify us when Realm changes
        self.notificationToken = self.realm.observe { _,_ in
          updateList()
        }
      }
    }
  }

  func setupUI() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.text
 //   cell.textLabel?.alpha = item.completed? 0.5: 1
    return cell
  }
  
  @objc func add() {
    let alertController = UIAlertController(title: "New Task", message: "Enter Task Name", preferredStyle: .alert)
    var alertTextField: UITextField!
    
    alertController.addTextField { textField in
      alertTextField = textField
      textField.placeholder = "Task Name"
    }
    
    alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
      guard let text = alertTextField.text, !text.isEmpty else { return }

      self.taskList.items.append(Task(value: ["text": text]))
      
      try! self.realm.write {
        self.realm.create(TaskList.self, value: self.taskList, update: true)
      }
      
      self.tableView.reloadData()
    })
    
    present(alertController, animated: true, completion: nil)
  }
}

