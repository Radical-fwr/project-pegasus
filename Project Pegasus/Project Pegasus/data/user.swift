//
//  user.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/11/23.
//

import SwiftUI
import SwiftData

@Model
class User: Identifiable {
    var nome: String
    @Attribute(.externalStorage) var avatar: Data?
    
    init(nome: String, avatar: Data? = nil) {
        self.nome = nome
        self.avatar = avatar
    }
}
