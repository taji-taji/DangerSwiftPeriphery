import XCTest
import Danger
@testable import DangerSwiftPeriphery

final class DangerSwiftPeripheryTests: XCTestCase {
    private var scanExecutor: PeripheryScanExecutableMock!
    private var outputParser: CheckstyleOutputParsableMock!
    private var diffProvider: PullRequestDiffProvidableMock!

    override func setUp() {
        super.setUp()

        scanExecutor = PeripheryScanExecutableMock()
        outputParser = CheckstyleOutputParsableMock()
        diffProvider = PullRequestDiffProvidableMock()
    }

    func testScanErrorOccurredWhileScanning() throws {
        scanExecutor.executeHandler = {
            throw TestError.scanError
        }
        outputParser.parseHandler = { _, _ in
            []
        }
        diffProvider.diffHandler = { _ in
            .success(.modified(hunks: []))
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          currentPathProvider: DefaultCurrentPathProvider(),
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
        outputParser.parseHandler = { _, _ in
            throw TestError.parseError
        }
        diffProvider.diffHandler = { _ in
            .success(.modified(hunks: []))
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          currentPathProvider: DefaultCurrentPathProvider(),
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
}

private extension DangerSwiftPeripheryTests {
    enum TestError: Error {
        case scanError
        case parseError
    }
}
