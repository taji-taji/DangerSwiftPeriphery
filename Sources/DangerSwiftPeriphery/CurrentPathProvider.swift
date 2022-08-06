//
//  CurrentPathProvider.swift
//
//  Created by 多鹿豊 on 2022/04/05.
//

import Foundation

struct CurrentPathProvider {
    private let fileManager: FileManager

    var currentPath: String {
        fileManager.currentDirectoryPath
    }
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
}
