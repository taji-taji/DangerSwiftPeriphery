//
//  CurrentPathProvider.swift
//
//  Created by 多鹿豊 on 2022/04/05.
//

import Foundation

protocol CurrentPathProvider {
    var currentPath: String { get }
}

struct DefaultCurrentPathProvider<SE: ShellExecutable>: CurrentPathProvider {
    private let shellExecutor: SE
    var currentPath: String {
        return try! shellExecutor.execute("pwd").get().trimmingCharacters(in: .newlines)
    }
    
    init(shellExecutor: SE) {
        self.shellExecutor = shellExecutor
    }
}

extension DefaultCurrentPathProvider where SE == ShellExecutor {
    init() {
        self.shellExecutor = .init()
    }
}
