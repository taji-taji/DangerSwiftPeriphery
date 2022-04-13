//
//  PeripheryScanCommandBuilder.swift
//  
//
//  Created by 多鹿豊 on 2022/04/09.
//

import Foundation

struct PeripheryScanCommandBuilder {
    private let peripheryPath: String
    private let additionalArguments: [String]
    private let overrideArgumentKeys: [String] = [
        "--format",
        "--quiet",
        "--disable-update-check"
    ]
    
    var command: String {
        // override --format, --quiet, --disable-update-check
        var overridedArguments: [String] = additionalArguments
        overridedArguments.removeAll(where: { argument -> Bool in
            overrideArgumentKeys.contains(where: { argument.hasPrefix($0) })
        })
        overridedArguments += [
            "--format checkstyle",
            "--quiet",
            "--disable-update-check"
        ]
        
        return peripheryPath + " scan " + overridedArguments.joined(separator: " ")
    }
    
    init(peripheryPath: String,
         additionalArguments: [String]) {
        self.peripheryPath = peripheryPath
        self.additionalArguments = additionalArguments
    }
}
