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
  var items = List<Task>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupUI()
    
    items.append(Task(value: ["text": "My First Task"]))
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
      
      self.items.append(Task(value: ["text" : text]))
      self.tableView.reloadData()
    })
    
    present(alertController, animated: true, completion: nil)
  }
}

