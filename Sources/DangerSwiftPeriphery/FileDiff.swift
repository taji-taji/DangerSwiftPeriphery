import Foundation

enum FileDiff {}

extension FileDiff {
    enum Changes {
        case created(addedLines: [String])
        case deleted(deletedLines: [String])
        case modified(hunks: [Hunk])
        case renamed(oldPath: String, hunks: [Hunk])
    }
}

extension FileDiff {
    struct Hunk {
        let oldLineStart: Int
        let oldLineSpan: Int
        let newLineStart: Int
        let newLineSpan: Int
    }
}
