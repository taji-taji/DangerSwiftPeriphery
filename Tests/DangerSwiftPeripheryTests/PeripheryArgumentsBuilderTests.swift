//
// Created by 多鹿豊 on 2022/07/27.
//

import XCTest
@testable import DangerSwiftPeriphery

final class PeripheryArgumentsBuilderTests: XCTestCase {
    private let trueCondition = true
    private let falseCondition = false

    func testBuildBlock() {
        assert({
            PeripheryArguments.config("/path/to/config")
            PeripheryArguments.workspace("test-workspace")
            PeripheryArguments.schemes(["scheme1", "scheme2"])
            PeripheryArguments.skipBuild
        }, expected: [
            "--config /path/to/config",
            "--workspace test-workspace",
            "--schemes scheme1 --schemes scheme2",
            "--skip-build"
        ])
    }

    func testBuildOptionalTrueCondition() {
        assert({
            PeripheryArguments.config("/path/to/config")
            PeripheryArguments.workspace("test-workspace")
            if trueCondition {
                PeripheryArguments.schemes(["scheme1", "scheme2"])
            }
            PeripheryArguments.skipBuild
        }, expected: [
            "--config /path/to/config",
            "--workspace test-workspace",
            "--schemes scheme1 --schemes scheme2",
            "--skip-build"
        ])
    }

    func testBuildOptionalFalseCondition() {
        assert({
            PeripheryArguments.config("/path/to/config")
            PeripheryArguments.workspace("test-workspace")
            if falseCondition {
                PeripheryArguments.schemes(["scheme1", "scheme2"])
            }
            PeripheryArguments.skipBuild
        }, expected: [
            "--config /path/to/config",
            "--workspace test-workspace",
            "--skip-build"
        ])
    }

    func testBuildEitherFirst() {
        assert({
            PeripheryArguments.config("/path/to/config")
            PeripheryArguments.workspace("test-workspace")
            if trueCondition {
                PeripheryArguments.schemes(["scheme1", "scheme2"])
            } else {
                PeripheryArguments.schemes(["scheme3", "scheme4"])
            }
            PeripheryArguments.skipBuild
        }, expected: [
            "--config /path/to/config",
            "--workspace test-workspace",
            "--schemes scheme1 --schemes scheme2",
            "--skip-build"
        ])
    }

    func testBuildEitherSecond() {
        assert({
            PeripheryArguments.config("/path/to/config")
            PeripheryArguments.workspace("test-workspace")
            if falseCondition {
                PeripheryArguments.schemes(["scheme1", "scheme2"])
            } else {
                PeripheryArguments.schemes(["scheme3", "scheme4"])
            }
            PeripheryArguments.skipBuild
        }, expected: [
            "--config /path/to/config",
            "--workspace test-workspace",
            "--schemes scheme3 --schemes scheme4",
            "--skip-build"
        ])
    }
}

private extension PeripheryArgumentsBuilderTests {
    func assert(@PeripheryArgumentsBuilder _ arguments: () -> [String], expected: [String]) {
        XCTAssertEqual(arguments(), expected)
    }
}
