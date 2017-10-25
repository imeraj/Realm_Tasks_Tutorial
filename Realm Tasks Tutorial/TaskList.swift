//
//  TaskList.swift
//  Realm Tasks Tutorial
//
//  Created by iMeraj-MacbookPro on 25/10/2017.
//Copyright © 2017 Meraj. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
      @objc dynamic var test = ""
      @objc dynamic var id = ""
      let items = List<Task>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
