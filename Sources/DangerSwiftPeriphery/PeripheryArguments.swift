//
// Created by 多鹿豊 on 2022/07/25.
//

import Foundation

public enum PeripheryArguments {
    case config(String)
    case workspace(String)
    case project(String)
    case schemes([String])
    case targets([String])
    case indexExclude([String])
    case reportExclude([String])
    case reportInclude([String])
    case indexStorePath(String)
    case retainPublic
    case disableRedundantPublicAnalysis
    case retainAssignOnlyProperties
    case retainAssignOnlyPropertyTypes([String])
    case externalEncodableProtocols([String])
    case retainObjcAccessible
    case retainUnusedProtocolFuncParams
    case cleanBuild
    case skipBuild
    case strict
    case custom(String)
}

public extension PeripheryArguments {
    var optionString: String {
        if case let .custom(value) = self {
            return value
        }
        if values.isEmpty {
            return key
        } else {
            return values
                .map { [key, $0].joined(separator: " ") }
                .joined(separator: " ")
        }
    }
}

private extension PeripheryArguments {
    var key: String {
        let reflection = Mirror(reflecting: self)
        guard reflection.displayStyle == .enum,
              let associated = reflection.children.first else {
            return "--" + "\(self)".kebabCased
        }
        return "--" + associated.label!.kebabCased
    }

    var values: [String] {
        let reflection = Mirror(reflecting: self)
        guard reflection.displayStyle == .enum,
              let associated = reflection.children.first else {
            return []
        }
        switch associated.value {
        case let value as String:
            return [value]
        case let values as [String]:
            return values
        default:
            return []
        }
    }
}

private extension String {
    var kebabCased: String {
        let pattern = "([a-z0-9])([A-Z])"

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }
        let range = NSRange(location: 0, length: count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1-$2").lowercased()
    }
}
