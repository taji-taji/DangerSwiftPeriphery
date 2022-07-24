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
        let shellExecutor = ShellExecutableMock()
        shellExecutor.executeHandler = { _, _ in
            .failure(.init(status: 9999, description: "test error"))
        }
        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: shellExecutor)
        
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
        let shellExecutor = ShellExecutableMock()
        shellExecutor.executeHandler = { _, _ in
            .success("""
                     test
                     test2
                     test3
                     test4
                     """)
        }

        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: shellExecutor)
        
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
        let shellExecutor = ShellExecutableMock()
        shellExecutor.executeHandler = { _, _ in
            .success("""
                     test
                     warning: hoge
                     test2
                     warning: fuga
                     test3
                     test4
                     """)
        }
        executor = PeripheryScanExecutor(commandBuilder: commandBuilder,
                                         shellExecutor: shellExecutor)
        
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
