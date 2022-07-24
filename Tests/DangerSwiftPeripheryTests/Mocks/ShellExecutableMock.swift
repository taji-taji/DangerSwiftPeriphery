//
// Created by 多鹿豊 on 2022/07/24.
//

import Foundation
@testable import DangerSwiftPeriphery

final class ShellExecutableMock: ShellExecutable {
    var executeHandler: ((String, [String]) -> Result<String, CommandError>)?

    func execute(_ command: String) -> Result<String, CommandError> {
        execute(command, arguments: [])
    }

    func execute(_ command: String, arguments: [String]) -> Result<String, CommandError> {
        guard let handler = executeHandler else {
            fatalError("executeHandler is nil.")
        }
        return handler(command, arguments)
    }
}
