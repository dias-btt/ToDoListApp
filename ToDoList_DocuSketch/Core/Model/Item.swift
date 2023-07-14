//
//  Item.swift
//  ToDoList_DocuSketch
//
//  Created by Диас Сайынов on 13.07.2023.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
}
