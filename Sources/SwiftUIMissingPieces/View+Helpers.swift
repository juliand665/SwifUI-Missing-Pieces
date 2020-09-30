import SwiftUI

public extension View {
	/// Applies the given closure to the view and returns the result.
	func `in`<T>(@ViewBuilder transform: (Self) throws -> T) rethrows -> T {
		try transform(self)
	}
	
	/// Tracks whether the view is hovered or not, updating the given binding accordingly.
	@available(iOS 13.4, *)
	func hoverState(_ isHovered: Binding<Bool>) -> some View {
		self.onHover { isHovered.wrappedValue = $0 }
	}
}
