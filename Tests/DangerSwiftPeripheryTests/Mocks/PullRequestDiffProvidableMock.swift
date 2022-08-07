//
// Created by 多鹿豊 on 2022/07/24.
//

import Foundation
@testable import DangerSwiftPeriphery

final class PullRequestDiffProvidableMock: PullRequestDiffProvidable {
    var diffHandler: ((String) throws -> FileDiff.Changes)?

    func diff(forFile: String) throws -> FileDiff.Changes {
        guard let handler = diffHandler else {
            fatalError("diffHandler is nil.")
        }
        return try handler(forFile)
    }
}
