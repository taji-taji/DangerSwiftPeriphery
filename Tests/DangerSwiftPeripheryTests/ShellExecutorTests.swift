import XCTest
@testable import DangerSwiftPeriphery

final class ShellExecutorTests: XCTestCase {
    private var shellExecutor: ShellExecutor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        shellExecutor = ShellExecutor()
    }

    func testExecutePeriphery() throws {
        let result = shellExecutor.execute("swift run periphery", arguments: ["version"])
        switch result {
        case .success:
            break
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
}
