import Foundation

protocol DangerCommentable {
    func warn(violation: Violation)
    func fail(_ message: String)
}
