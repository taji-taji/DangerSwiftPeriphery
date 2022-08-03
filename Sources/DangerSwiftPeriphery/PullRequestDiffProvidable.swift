import Foundation

protocol PullRequestDiffProvidable {
    func diff(forFile: String) -> Result<FileDiff.Changes, Error>
}
