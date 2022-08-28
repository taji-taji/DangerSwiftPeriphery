import Danger
import DangerSwiftPeriphery

SwiftLint.lint()

DangerPeriphery.scan(arguments: [
    .retainPublic
])
