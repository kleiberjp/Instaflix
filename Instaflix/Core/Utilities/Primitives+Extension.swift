//
//  Optionals + Extension.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation

extension Optional {
    
    var isNull: Bool {
        return self == nil
    }
}

extension Optional where Wrapped: Collection {
    
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional where Wrapped: StringProtocol {
    
    var isNullOrEmptyValue: Bool {
        guard let value = self else { return true }

        return value.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension String {

    var isNumeric: Bool {
        return NumberFormatter().number(from: self) != nil
    }

    func trimmingAllSpaceString() -> String {
         var strText = self
         strText = strText.replacingOccurrences(of: " ", with: "")
         strText = strText.replacingOccurrences(of: " ", with: "")
         return strText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
     }

     func trimmingString() -> String {
       return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    static let empty: String = ""
}

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
    var isRunningUITests: Bool {
        return arguments.contains("isRunningUITests")
    }
}
