import Foundation

@available(*, deprecated, renamed: "PeripheryScanOptions")
public typealias PeripheryArguments = PeripheryScanOptions

/// periphery scan command options
public enum PeripheryScanOptions {
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
    case externalTestCaseClasses([String])
    case retainObjcAccessible
    case retainObjcAnnotated
    case retainUnusedProtocolFuncParams
    case cleanBuild
    case retainSwiftUIPreviews
    case skipBuild
    case relativeResults
    case strict
    case custom(String)
}

extension PeripheryScanOptions {
    var optionString: String {
        switch self {
        case .config(let config):
            "--config \(config)"
        case .workspace(let workspace):
            "--workspace \(workspace)"
        case .project(let project):
            "--project \(project)"
        case .schemes(let schemes):
            schemes
                .map({ "--schemes \($0)" })
                .joined(separator: " ")
        case .targets(let targets):
            targets
                .map({ "--targets \($0)" })
                .joined(separator: " ")
        case .indexExclude(let indexes):
            indexes
                .map({ "--index-exclude \($0)" })
                .joined(separator: " ")
        case .reportExclude(let reports):
            reports
                .map({ "--report-exclude \($0)" })
                .joined(separator: " ")
        case .reportInclude(let reports):
            reports
                .map({ "--report-include \($0)" })
                .joined(separator: " ")
        case .indexStorePath(let path):
            "--index-store-path \(path)"
        case .retainPublic:
            "--retain-public"
        case .disableRedundantPublicAnalysis:
            "--disable-redundant-public-analysis"
        case .retainAssignOnlyProperties:
            "--retain-assign-only-properties"
        case .retainAssignOnlyPropertyTypes(let types):
            types
                .map({ "--retain-assign-only-property-types \($0)" })
                .joined(separator: " ")
        case .externalEncodableProtocols(let protocols):
            protocols
                .map({ "--external-encodable-protocols \($0)" })
                .joined(separator: " ")
        case .externalTestCaseClasses(let classes):
            classes
                .map({ "--external-test-case-classes \($0)" })
                .joined(separator: " ")
        case .retainObjcAccessible:
            "--retain-objc-accessible"
        case .retainObjcAnnotated:
            "--retain-objc-annotated"
        case .retainUnusedProtocolFuncParams:
            "--retain-unused-protocol-func-params"
        case .cleanBuild:
            "--clean-build"
        case .retainSwiftUIPreviews:
            "--retain-swift-ui-previews"
        case .skipBuild:
            "--skip-build"
        case .relativeResults:
            "--relative-results"
        case .strict:
            "--strict"
        case .custom(let option):
            option
        }
    }
}
