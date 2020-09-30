import SwiftUI

public extension View {
	/**
	Tracks the given environment value, calling a closure when it changes.
	The closure is also called with the initial value, so it will provide you with the correct value even before it changes.
	
	- Parameters:
		- key: the environment value key path to track, as you'd provide to `@Environment`.
		- onChange: the closure to call when the value changes, as well as with the initial value.
		- value: the current value of the environment value.
	*/
	func trackingEnvironment<Value>(
		_ key: KeyPath<EnvironmentValues, Value>,
		onChange: @escaping (_ value: Value) -> Void
	) -> some View where Value: Equatable {
		self.background(
			EnvironmentTracker<Value>(key: key)
				.onPreferenceChange(EnvironmentKey<Value>.self) { onChange($0!) }
		)
	}
}

private struct EnvironmentTracker<Value>: View {
	@Environment var environmentValue: Value
	
	init(key: KeyPath<EnvironmentValues, Value>) {
		self._environmentValue = Environment(key)
	}
	
	var body: some View {
		Color.clear.preference(key: EnvironmentKey<Value>.self, value: environmentValue)
	}
}

private typealias EnvironmentKey<Value> = SimplePreferenceKey<EnvironmentTrackerMarker, Value>
private enum EnvironmentTrackerMarker {}

