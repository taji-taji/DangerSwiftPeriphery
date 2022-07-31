//
//  PeripheryScanExecutor.swift
//  
//
//  Created by 多鹿豊 on 2022/04/09.
//

import Foundation

protocol PeripheryScanExecutable {
    func execute() throws -> String
}

struct PeripheryScanExecutor<SE: ShellExecutable>: PeripheryScanExecutable {
    private let commandBuilder: PeripheryScanCommandBuilder
    private let shellExecutor: SE
    private let warnPrefix = "warning: "
    
    init(commandBuilder: PeripheryScanCommandBuilder,
         shellExecutor: SE) {
        self.commandBuilder = commandBuilder
        self.shellExecutor = shellExecutor
    }
    
    func execute() throws -> String {
        switch shellExecutor.execute(commandBuilder.command) {
        case .success(let output):
            var outputLines = output.split(whereSeparator: \.isNewline)
            outputLines.removeAll(where: { $0.hasPrefix(warnPrefix) })
            Logger.shared.debug("scan output: \(outputLines)")
            return outputLines.joined(separator: "\n")
        case .failure(let error):
            throw error
        }
    }
}

extension PeripheryScanExecutor where SE == ShellExecutor {
    init(commandBuilder: PeripheryScanCommandBuilder) {
        self.commandBuilder = commandBuilder
        shellExecutor = .init()
    }
}

extension PeripheryScanExecutor {
    struct Error: Swift.Error, CustomStringConvertible {
        let description: String
    }
}
