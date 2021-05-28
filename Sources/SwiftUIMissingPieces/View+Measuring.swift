import SwiftUI

public extension View {
	/**
	Measures this view, calling the given closure when the size changes (thus also initially).
	
	Be careful to not create infinite layout loops with this.
	
	- Parameters:
		- onChange: a callback to call when the size changes.
		- size: the new measured size of the view.
	*/
	func measured(onChange: @escaping (_ size: CGSize) -> Void) -> some View {
		self.modifier(Measured(onChange: onChange))
	}
}

private struct Measured: ViewModifier {
	let onChange: (_ size: CGSize) -> Void
	
	func body(content: Content) -> some View {
		content
			.background(
				GeometryReader { proxy in
					Color.clear.preference(key: SizeKey.self, value: proxy.size)
				}
				.hidden()
			)
			.onPreferenceChange(SizeKey.self) { onChange($0!) }
	}
}

private typealias SizeKey = SimplePreferenceKey<SizeKeyMarker, CGSize>
private enum SizeKeyMarker {}
