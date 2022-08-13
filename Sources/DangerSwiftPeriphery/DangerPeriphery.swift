//
//  DangerPeriphery.swift
//  
//
//  Created by 多鹿豊 on 2022/03/31.
//

import Danger

public struct DangerPeriphery {
    @discardableResult
    public static func scan(peripheryExecutable: String = "swift run periphery",
                            @PeripheryArgumentsBuilder arguments: () -> [String],
                            shouldComment: Bool = true,
                            verbose: Bool = false) -> Result<[Violation] , Error> {
        scan(peripheryExecutable: peripheryExecutable,
             arguments: arguments(),
             shouldComment: shouldComment,
             verbose: verbose)
    }

    @discardableResult
    public static func scan(peripheryExecutable: String = "swift run periphery",
                            arguments: [PeripheryArguments],
                            shouldComment: Bool = true,
                            verbose: Bool = false) -> Result<[Violation] , Error> {
        scan(peripheryExecutable: peripheryExecutable,
             arguments: arguments.map { $0.optionString },
             shouldComment: shouldComment,
             verbose: verbose)
    }

    @discardableResult
    public static func scan(peripheryExecutable: String = "swift run periphery",
                            arguments: [String] = [],
                            shouldComment: Bool = true,
                            verbose: Bool = false) -> Result<[Violation] , Error> {
        Logger.shared.verbose = verbose

        // make dependencies
        let commandBuilder = PeripheryScanCommandBuilder(peripheryExecutable: peripheryExecutable,
                                                         additionalArguments: arguments)
        let scanExecutor = PeripheryScanExecutor(commandBuilder: commandBuilder)
        let danger = Danger()
        let currentPathProvider = CurrentPathProvider()
        let outputParser = CheckstyleOutputParser(projectRootPath: currentPathProvider.currentPath)
        
        // execute scan
        let result = self.scan(scanExecutor: scanExecutor,
                               outputParser: outputParser,
                               diffProvider: danger)
        
        // handle scan result
        handleScanResult(result, danger: danger, shouldComment: shouldComment)
        return result
    }
    
    static func scan<PSE: PeripheryScanExecutable,
                     OP: CheckstyleOutputParsable,
                     DP: PullRequestDiffProvidable>(
                        scanExecutor: PSE,
                        outputParser: OP,
                        diffProvider: DP) -> Result<[Violation], Error> {
        Result {
            let output = try scanExecutor.execute()
            let allViolations = try outputParser.parse(xml: output)
            let violationsForComment = try allViolations.filter({ try isViolationIncludedInInsertions($0, diffProvider: diffProvider) })
            return violationsForComment
        }
    }

    static func isViolationIncludedInInsertions(_ violation: Violation, diffProvider: PullRequestDiffProvidable) throws -> Bool {
        let changes = try diffProvider.diff(forFile: violation.filePath)
        // comment only `Created files` and `Files that have been modified and are contained within hunk`
        switch changes {
        case .created:
            return true
        case .deleted:
            return false
        case let .modified(hunks):
            return hunks.contains(where: { $0.newLineRange.contains(violation.line) })
        case .renamed:
            return false
        }
    }

    static func handleScanResult<DC: DangerCommentable>(_ scanResult: Result<[Violation], Error>,
                                                        danger: DC,
                                                        shouldComment: Bool) {
        guard shouldComment else { return }
        switch scanResult {
        case .success(let violations):
            for violation in violations {
                danger.warn(violation: violation)
            }
        case .failure(let error):
            danger.fail(error.localizedDescription)
        }
    }
}
