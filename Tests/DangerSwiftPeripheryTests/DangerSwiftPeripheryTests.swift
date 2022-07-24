import XCTest
import Danger
@testable import DangerSwiftPeriphery

final class DangerSwiftPeripheryTests: XCTestCase {
    func testScanErrorOccurredWhileScanning() throws {
        let scanExecutor = PeripheryScanExecutableMock()
        scanExecutor.executeHandler = {
            throw TestError.scanError
        }
        let outputParser = CheckstyleOutputParsableMock(projectRootPath: DefaultCurrentPathProvider().currentPath)
        outputParser.parseHandler = { _ in
            []
        }
        let diffProvider = PullRequestDiffProvidableMock()
        diffProvider.diffHandler = { _ in
            .success(.modified(hunks: []))
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          outputParser: outputParser,
                                          diffProvider: diffProvider)
        switch result {
        case .success:
            XCTFail("Unexpected success")
        case .failure(let error as TestError):
            switch error {
            case .scanError:
                // noop
                break
            default:
                XCTFail("Unexpected error")
            }
        default:
            XCTFail("Unexpected result")
        }
    }
    
    func testScanErrorOccurredWhileParsingResult() throws {
        let scanExecutor = PeripheryScanExecutableMock()
        scanExecutor.executeHandler = {
            "test"
        }
        let outputParser = CheckstyleOutputParsableMock(projectRootPath: DefaultCurrentPathProvider().currentPath)
        outputParser.parseHandler = { _ in
            throw TestError.parseError
        }
        let diffProvider = PullRequestDiffProvidableMock()
        diffProvider.diffHandler = { _ in
            .success(.modified(hunks: []))
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          outputParser: outputParser,
                                          diffProvider: diffProvider)
        switch result {
        case .success:
            XCTFail("Unexpected success")
        case .failure(let error as TestError):
            switch error {
            case .parseError:
                // noop
                break
            default:
                XCTFail("Unexpected error")
            }
        default:
            XCTFail("Unexpected result")
        }
    }

    func testScanNoCommentViolationsWithoutCreatedOrModifiedDiff() {
        let scanExecutor = PeripheryScanExecutableMock()
        scanExecutor.executeHandler = { "test" }
        let outputParser = CheckstyleOutputParsableMock(projectRootPath: DefaultCurrentPathProvider().currentPath)
        outputParser.parseHandler = { _ in
            [
                .init(filePath: "path1", line: 1, message: "1"),
                .init(filePath: "path2", line: 2, message: "2"),
            ]
        }
        let diffProvider = PullRequestDiffProvidableMock()
        diffProvider.diffHandler = { filePath in
            switch filePath {
            case "path1":
                return .success(.deleted(deletedLines: []))
            case "path2":
                return .success(.renamed(oldPath: "", hunks: []))
            default:
                return .success(.deleted(deletedLines: []))
            }
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          outputParser: outputParser,
                                          diffProvider: diffProvider)
        switch result {
        case let .success(violationsForComment):
            XCTAssertEqual(violationsForComment.count, 0)
        case .failure:
            XCTFail("Unexpected error")
        }
    }
}

private extension DangerSwiftPeripheryTests {
    enum TestError: Error {
        case scanError
        case parseError
    }
}
