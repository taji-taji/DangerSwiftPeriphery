//
// Created by 多鹿豊 on 2022/07/26.
//

import Foundation

@resultBuilder
public struct PeripheryArgumentsBuilder {
    public static func buildBlock(_ components: PeripheryArguments...) -> [PeripheryArguments] {
        components
    }

    public static func buildEither(first component: [PeripheryArguments]) -> PeripheryArguments {
        component.first ?? .custom("")
    }

    public static func buildEither(second component: [PeripheryArguments]) -> PeripheryArguments {
        component.first ?? .custom("")
    }

    public static func buildOptional(_ component: [PeripheryArguments]?) -> PeripheryArguments {
        component?.first ?? .custom("")
    }

    public static func buildFinalResult(_ component: [PeripheryArguments]) -> [String] {
        component.compactMap { $0.optionString.isEmpty ? nil : $0.optionString }
    }

    public static func buildArray(_ components: [[PeripheryArguments]]) -> PeripheryArguments {
        .custom(
            components
                .flatMap { $0.map { $0.optionString } }
                .joined(separator: " ")
        )
    }
}
