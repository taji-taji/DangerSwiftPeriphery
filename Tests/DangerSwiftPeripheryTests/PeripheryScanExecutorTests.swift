//
//  PeripheryScanExecutorTests.swift
//  
//
//  Created by 多鹿豊 on 2022/04/09.
//

import XCTest
@testable import DangerSwiftPeriphery

final class PeripheryScanExecutorTests: XCTestCase {
    private var executor: PeripheryScanExecutable!
    private var commandBuilder: PeripheryScanCommandBuilder!
    
    override func setUpWithError() throws {
        commandBuilder = PeripheryScanCommandBuilder(peripheryPath: "", additionalArguments: [])
    }

    override func tearDownWithError() throws {
        executor = nil
    }

    func testExecuteThrowCommandError() throws {
        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: ErrorShellExecutor(status: 9999, description: "test error"))
        
        do {
            _ = try executor.execute()
            XCTFail("Must throw error.")
        } catch {
            if let error = error as? CommandError {
                XCTAssertEqual(error.status, 9999)
                XCTAssertEqual(error.description, "test error")
            } else {
                XCTFail("Unexpected error.")
            }
        }
    }
    
    func testExecuteSucceed() throws {
        let succeedShellExecutor = SucccedShellExecutor(output: """
        test
        test2
        test3
        test4
        """)
        
        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: succeedShellExecutor)
        
        do {
            let output = try executor.execute()
            let expected = """
            test
            test2
            test3
            test4
            """
            
            XCTAssertEqual(output, expected)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testExecuteSucceedWithWarning() throws {
        let succeedShellExecutor = SucccedShellExecutor(output: """
        test
        warning: hoge
        test2
        warning: fuga
        test3
        test4
        """)
        
        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: succeedShellExecutor)
        
        do {
            let output = try executor.execute()
            let expected = """
            test
            test2
            test3
            test4
            """
            
            XCTAssertEqual(output, expected)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

private extension PeripheryScanExecutorTests {
    final class ErrorShellExecutor: ShellExecutable {
        private let status: Int32
        private let description: String
        
        init(status: Int32, description: String) {
            self.status = status
            self.description = description
        }
        
        func execute(_ command: String) -> Result<String, CommandError> {
            execute(command, arguments: [])
        }
        
        func execute(_ command: String, arguments: [String]) -> Result<String, CommandError> {
            .failure(.init(status: status, description: description))
        }
    }
    
    final class SucccedShellExecutor: ShellExecutable {
        private let output: String
        
        init(output: String) {
            self.output = output
        }
        
        func execute(_ command: String) -> Result<String, CommandError> {
            execute(command, arguments: [])
        }
        
        func execute(_ command: String, arguments: [String]) -> Result<String, CommandError> {
            .success(output)
        }
    }
}
