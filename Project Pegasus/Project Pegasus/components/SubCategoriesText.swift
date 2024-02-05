//
//  SubCategoriesText.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 05/02/24.
//

import SwiftUI

struct SubCategoriesText: View {
    @State var selectedSubCategory: SubCategory?
    var body: some View {
        if let selectedSubCategory = selectedSubCategory {
            Text(selectedSubCategory.name)
                .font(Font.custom("HelveticaNeue", size: 15))
        } else {
            Text(selectedSubCategory!.name)
                .font(Font.custom("HelveticaNeue", size: 15))
        }
    }
}
