//
//  Task.swift
//  Realm Tasks Tutorial
//
//  Created by iMeraj-MacbookPro on 25/10/2017.
//Copyright © 2017 Meraj. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
  @objc dynamic var text = ""
  @objc dynamic var completed = false
}
