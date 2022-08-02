//
// Created by 多鹿豊 on 2022/08/02.
//

import Foundation
@testable import DangerSwiftPeriphery

final class DangerCommentableMock: DangerCommentable {
    var warnHandler: ((String, String, Int) -> Void)?
    var failHandler: ((String) -> Void)?
    private(set) var warnCallCount = 0
    private(set) var failCallCount = 0

    func warn(message: String, file: String, line: Int) {
        warnCallCount += 1
        guard let handler = warnHandler else {
            fatalError("warnHandler is nil.")
        }
        handler(message, file, line)
    }

    func fail(_ message: String) {
        failCallCount += 1
        guard let handler = failHandler else {
            fatalError("failHandler is nil.")
        }
        handler(message)
    }
}
