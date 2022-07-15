import XCTest
import Danger
@testable import DangerSwiftPeriphery

final class DangerSwiftPeripheryTests: XCTestCase {
    func testScanErrorOccuredWhileScanning() throws {
        let scanExecutor = ErrorScanExecutor(errorMessage: "test error")
        let result = DangerPeriphery.scan(scanExecutor: scanExecutor,
                                          outputParser: CheckstyleOutputParser(projectRootPath: DefaultCurrentPathProvider().currentPath),
                                          diffProvider: DiffProviderMock(result: .failure(TestError.scanError(messege: ""))))
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
    
    func testScanErrorOccuredWhileParsingResult() throws {
        
    }
}

private extension DangerSwiftPeripheryTests {
    enum TestError: Error {
        case scanError(messege: String)
    }

    final class ErrorScanExecutor: PeripheryScanExecutable {
        let errorMessage: String
        
        init(errorMessage: String) {
            self.errorMessage = errorMessage
        }
        
        func execute() throws -> String {
            throw TestError.scanError(messege: errorMessage)
        }
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
