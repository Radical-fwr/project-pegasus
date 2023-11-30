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
    @Attribute(.unique) var nome: String
    @Attribute(.externalStorage) var imageData: Data?
    
    init(nome: String) {
        self.nome = nome
    }
}
