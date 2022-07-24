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
        
    }
}

private extension DangerSwiftPeripheryTests {
    enum TestError: Error {
        case scanError(message: String)
    }
}
