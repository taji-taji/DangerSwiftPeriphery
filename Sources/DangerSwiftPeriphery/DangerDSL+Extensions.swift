import Danger

extension DangerDSL: DangerCommentable {}

extension DangerDSL: PullRequestDiffProvidable {
    func diff(forFile file: String) -> Result<FileDiff.Changes, Error> {
        utils.diff(forFile: file, sourceBranch: sourceBranch())
             .map {
                 switch $0.changes {
                 case let .created(addedLines):
                     return .created(addedLines: addedLines)
                 case let .renamed(oldPath, hunks):
                     return .renamed(oldPath: oldPath,
                                     hunks: hunks.map { .init(from: $0) } )
                 case let .modified(hunks):
                     return .modified(hunks: hunks.map { .init(from: $0) })
                 case let .deleted(deletedLines):
                     return .deleted(deletedLines: deletedLines)
                 }
             }
    }

    private func sourceBranch() -> String {
        if let github = github {
            return "origin/\(github.pullRequest.base.ref)..HEAD"
        } else if let gitLab = gitLab {
            return gitLab.mergeRequest.targetBranch
        } else if let bitbucketCloud = bitbucketCloud {
            return bitbucketCloud.pr.destination.branchName
        } else if let bitbucketServer = bitbucketServer {
            return bitbucketServer.pullRequest.fromRef.displayId
        }
        return ""
    }
}

private extension FileDiff.Hunk {
    init(from dangerHunk: Danger.FileDiff.Hunk) {
        oldLineStart = dangerHunk.oldLineStart
        oldLineSpan = dangerHunk.oldLineSpan
        newLineStart = dangerHunk.newLineStart
        newLineSpan = dangerHunk.newLineSpan
    }
}