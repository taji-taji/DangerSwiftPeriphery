//
//  CurrentPathProvider.swift
//
//  Created by 多鹿豊 on 2022/04/05.
//

import Foundation

struct DefaultCurrentPathProvider<SE: ShellExecutable> {
    private let shellExecutor: SE
    var currentPath: String {
        try! shellExecutor.execute("pwd").get().trimmingCharacters(in: .newlines)
    }
    
    init(shellExecutor: SE) {
        self.shellExecutor = shellExecutor
    }
}

extension DefaultCurrentPathProvider where SE == ShellExecutor {
    init() {
        shellExecutor = .init()
    }
}
