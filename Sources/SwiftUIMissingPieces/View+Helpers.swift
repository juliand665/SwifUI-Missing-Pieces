import SwiftUI

public extension View {
	/// Applies the given closure to the view and returns the result.
	func `in`<V: View>(@ViewBuilder transform: (Self) throws -> V) rethrows -> V {
		try transform(self)
	}
	
	/// Applies the given closure to a view _if_ the given condition is true, returning the result.
	/// 
	/// Really just shorthand for the most common use of `in`.
	@ViewBuilder
	func `if`<V: View>(_ condition: Bool, @ViewBuilder transform: (Self) throws -> V) rethrows -> some View {
		if condition {
			try transform(self)
		} else {
			self
		}
	}
	
	/// Applies the given closure to a view _if_ the given optional is non-nil, returning the result.
	@ViewBuilder
	func ifLet<T, V: View>(_ value: T?, @ViewBuilder transform: (Self, T) throws -> V) rethrows -> some View {
		if let value = value {
			try transform(self, value)
		} else {
			self
		}
	}
	
	/// Tracks whether the view is hovered or not, updating the given binding accordingly.
	@available(iOS 13.4, *)
	func hoverState(_ isHovered: Binding<Bool>) -> some View {
		self.onHover { isHovered.wrappedValue = $0 }
	}
}
