//
//  PullRequestDiffProvider.swift
//  
//
//  Created by 多鹿豊 on 2022/04/10.
//

import Foundation
import Danger

protocol PullRequestDiffProvidable {
    func diff(forFile: String) -> Result<FileDiff.Changes, Error>
}

struct PullRequestDiffProvider: PullRequestDiffProvidable {
    private let dangerDSL: DangerDSL
    
    init(dangerDSL: DangerDSL) {
        self.dangerDSL = dangerDSL
    }
    
    func diff(forFile file: String) -> Result<FileDiff.Changes, Error> {
        switch dangerDSL.utils.diff(forFile: file, sourceBranch: sourceBranch()) {
        case .success(let diff):
            return .success(diff.changes)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func sourceBranch() -> String {
        if let github = dangerDSL.github {
            return "origin/\(github.pullRequest.base.ref)..HEAD"
        } else if let gitLab = dangerDSL.gitLab {
            return gitLab.mergeRequest.targetBranch
        } else if let bitbucketCloud = dangerDSL.bitbucketCloud {
            return bitbucketCloud.pr.destination.branchName
        } else if let bitbucketServer = dangerDSL.bitbucketServer {
            return bitbucketServer.pullRequest.fromRef.displayId
        }
        return ""
    }
}
