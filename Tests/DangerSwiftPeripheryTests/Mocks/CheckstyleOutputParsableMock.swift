//
// Created by 多鹿豊 on 2022/07/24.
//

import Foundation
@testable import DangerSwiftPeriphery

final class CheckstyleOutputParsableMock: CheckstyleOutputParsable {
    var parseHandler: ((String, String) throws -> [Violation])?

    func parse(xml: String, projectRootPath: String) throws -> [Violation] {
        guard let handler = parseHandler else {
            fatalError("parseHandler is nil.")
        }
        return try handler(xml, projectRootPath)
    }
}
