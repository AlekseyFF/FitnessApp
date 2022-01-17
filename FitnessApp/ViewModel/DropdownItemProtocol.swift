//
//  DroopdownItemProtocol.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 24.12.2021.
//

import Foundation

protocol DropDownItemProtocol {
    var options: [DropdownOption] {
        get
    }
    var headerTitle: String {get}
    var dropdownTitle: String {get}
    var isSelected : Bool {get set}
    var selectedOption: DropdownOption {get set}
}
protocol DropdownOptionProtocol {
    var toDropdownOption: DropdownOption {
        get
    }
}
struct DropdownOption {
    enum DropdownOptionType {
        case text(String)
        case number(Int)
    }
    let type : DropdownOptionType
    let formatted: String
}



