//
// Created by 多鹿豊 on 2022/07/24.
//

import Foundation
@testable import DangerSwiftPeriphery

final class PullRequestDiffProvidableMock: PullRequestDiffProvidable {
    var diffHandler: ((String) -> Result<FileDiff.Changes, Error>)?

    func diff(forFile: String) -> Result<FileDiff.Changes, Error> {
        guard let handler = diffHandler else {
            fatalError("diffHandler is nil.")
        }
        return handler(forFile)
    }
}
