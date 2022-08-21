//
//  CheckstyleOutputParser.swift
//  
//
//  Created by 多鹿豊 on 2022/04/03.
//

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

protocol CheckstyleOutputParsable {
    func parse(xml: String) throws -> [Violation]
}

struct CheckstyleOutputParser: CheckstyleOutputParsable {
    private let projectRootPath: String

    init(projectRootPath: String) {
        self.projectRootPath = projectRootPath
    }

    func parse(xml: String) throws -> [Violation] {
        let parser = XMLParser(data: xml.data(using: .utf8)!)
        let delegate = CheckstyleOutputParserDelegate(projectRootPath: projectRootPath)
        parser.delegate = delegate
        parser.parse()

        if !delegate.hasCheckstyleElement {
            throw Error.invalidCheckstyleXML
        }
        return delegate.violations
    }
}

final class CheckstyleOutputParserDelegate: NSObject, XMLParserDelegate {
    private let projectRootPath: String
    private var filePath: String?
    private var line: Int?
    private var message: String?
    private(set) var violations: [Violation] = []
    private(set) var hasCheckstyleElement = false

    init(projectRootPath: String) {
        self.projectRootPath = projectRootPath
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "checkstyle":
            hasCheckstyleElement = true
        case "file":
            filePath = attributeDict["name"]?
                    .deletingPrefix(projectRootPath)
                    .deletingPrefix("/")
        case "error":
            line = Int(attributeDict["line"] ?? "")
            message = attributeDict["message"]
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "file":
            filePath = nil
        case "error":
            if let filePath = filePath,
               let line = line,
               let message = message {
                violations.append(Violation(filePath: filePath, line: line, message: message))
            }
            line = nil
            message = nil
        default:
            break
        }
    }
}

extension CheckstyleOutputParser {
    enum Error: Swift.Error {
        case invalidCheckstyleXML
    }
}

private extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
