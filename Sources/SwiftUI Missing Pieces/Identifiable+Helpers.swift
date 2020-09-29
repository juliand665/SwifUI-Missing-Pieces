import Foundation

public extension RangeReplaceableCollection where Element: Identifiable {
	/// Removes all elements (usually at most one) with the same ID as the given one.
	mutating func removeByID(_ element: Element) {
		removeAll { $0.id == element.id }
	}
}
