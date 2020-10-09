import Foundation

/// Lets you easily associate a tag with a value while keeping the value's ID.
public struct Tagged<Value, Tag> {
	public let value: Value
	public let tag: Tag
	
	public init(_ value: Value, with tag: Tag) {
		self.value = value
		self.tag = tag
	}
}

extension Tagged: Identifiable where Value: Identifiable {
	public var id: Value.ID { value.id }
}

public extension Collection {
	func taggedWithIndex() -> [Tagged<Element, Index>] {
		zip(self, self.indices).map(Tagged.init)
	}
}
