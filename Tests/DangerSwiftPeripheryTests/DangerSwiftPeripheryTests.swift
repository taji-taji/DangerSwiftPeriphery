import XCTest
import Danger
@testable import DangerSwiftPeriphery

final class DangerSwiftPeripheryTests: XCTestCase {
    func testScanErrorOccurredWhileScanning() throws {
        let scanExecutor = PeripheryScanExecutableMock()
        scanExecutor.executeHandler = {
            throw TestError.scanError(message: "test error")
        }
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          outputParser: CheckstyleOutputParser(projectRootPath: DefaultCurrentPathProvider().currentPath),
                                          diffProvider: DiffProviderMock(result: .failure(TestError.scanError(message: ""))))
        switch result {
        case .success:
            XCTFail("Unexpected success")
        case .failure(let error as TestError):
            switch error {
            case .scanError(let message):
                XCTAssertEqual(message, "test error")
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

    final class DiffProviderMock: PullRequestDiffProvidable {
        private let result: Result<FileDiff.Changes, Error>
        
        init(result: Result<FileDiff.Changes, Error>) {
            self.result = result
        }
        
        func diff(forFile: String) -> Result<FileDiff.Changes, Error> {
            result
        }
    }
}
