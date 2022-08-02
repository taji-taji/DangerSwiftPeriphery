import XCTest
import Danger
@testable import DangerSwiftPeriphery

final class DangerSwiftPeripheryTests: XCTestCase {
    private var scanExecutor: PeripheryScanExecutableMock!
    private var outputParser: CheckstyleOutputParsableMock!
    private var diffProvider: PullRequestDiffProvidableMock!
    private var dangerCommentable: DangerCommentableMock!

    override func setUp() {
        super.setUp()

        scanExecutor = PeripheryScanExecutableMock()
        outputParser = CheckstyleOutputParsableMock(projectRootPath: DefaultCurrentPathProvider().currentPath)
        diffProvider = PullRequestDiffProvidableMock()
        dangerCommentable = DangerCommentableMock()
    }

    func testScanErrorOccurredWhileScanning() throws {
        scanExecutor.executeHandler = {
            throw TestError.scanError
        }
        outputParser.parseHandler = { _ in
            []
        }
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
        scanExecutor.executeHandler = {
            "test"
        }
        outputParser.parseHandler = { _ in
            throw TestError.parseError
        }
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
        scanExecutor.executeHandler = { "test" }
        outputParser.parseHandler = { _ in
            [
                .init(filePath: "path1", line: 1, message: "1"),
                .init(filePath: "path2", line: 2, message: "2"),
            ]
        }
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

    func testHandleScanResultSuccessShouldComment() {
        XCTAssertEqual(dangerCommentable.warnCallCount, 0)
        dangerCommentable.warnHandler = { _, _, _ in  }

        let scanResult: Result<[DangerSwiftPeriphery.Violation], Error> = .success([
            .init(filePath: "path1", line: 1, message: "1"),
            .init(filePath: "path2", line: 2, message: "2"),
        ])
        DangerPeriphery.handleScanResult(scanResult,
                                         danger: dangerCommentable,
                                         shouldComment: true)

        XCTAssertEqual(dangerCommentable.warnCallCount, 2)
    }

    func testHandleScanResultFailureShouldComment() {
        XCTAssertEqual(dangerCommentable.failCallCount, 0)
        dangerCommentable.failHandler = { _ in  }

        let scanResult: Result<[DangerSwiftPeriphery.Violation], Error> = .failure(TestError.scanError)
        DangerPeriphery.handleScanResult(scanResult,
                                         danger: dangerCommentable,
                                         shouldComment: true)

        XCTAssertEqual(dangerCommentable.failCallCount, 1)
    }

    func testHandleScanResultSuccessShouldNotComment() {
        XCTAssertEqual(dangerCommentable.warnCallCount, 0)
        dangerCommentable.warnHandler = { _, _, _ in  }

        let scanResult: Result<[DangerSwiftPeriphery.Violation], Error> = .success([
            .init(filePath: "path1", line: 1, message: "1"),
            .init(filePath: "path2", line: 2, message: "2"),
        ])
        DangerPeriphery.handleScanResult(scanResult,
                                         danger: dangerCommentable,
                                         shouldComment: false)

        XCTAssertEqual(dangerCommentable.warnCallCount, 0)
    }

    func testHandleScanResultFailureShouldNotComment() {
        XCTAssertEqual(dangerCommentable.failCallCount, 0)
        dangerCommentable.failHandler = { _ in  }

        let scanResult: Result<[DangerSwiftPeriphery.Violation], Error> = .failure(TestError.scanError)
        DangerPeriphery.handleScanResult(scanResult,
                                         danger: dangerCommentable,
                                         shouldComment: false)

        XCTAssertEqual(dangerCommentable.failCallCount, 0)
    }
}

private extension DangerSwiftPeripheryTests {
    enum TestError: Error {
        case scanError
        case parseError
    }
}
