//
//  ShellExecutor.swift
//  
//
//  Created by 多鹿豊 on 2022/03/31.
//

import Foundation

protocol ShellExecutable {
    func execute(_ command: String) -> Result<String, CommandError>
    func execute(_ command: String, arguments: [String]) -> Result<String, CommandError>
}

extension ShellExecutable {
    func execute(_ command: String) -> Result<String, CommandError> {
        execute(command, arguments: [])
    }
}

struct CommandError: Error, CustomStringConvertible {
    let status: Int32
    let description: String
}

struct ShellExecutor: ShellExecutable {
    func execute(_ command: String, arguments: [String] = []) -> Result<String, CommandError> {
        let script = "\(command) \(arguments.joined(separator: " "))"
        Logger.shared.debug("command started: \(script)")

        let env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", script]
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.launch()
        task.waitUntilExit()

        let outputMessage = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
        let errorMessage = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)

        let status = task.terminationStatus
        if status == 0 {
            Logger.shared.debug("command output: " + outputMessage!)
            return .success(outputMessage!)
        } else {
            return .failure(.init(status: status, description: errorMessage!))
        }
    }
}
