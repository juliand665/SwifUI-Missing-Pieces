import SwiftUI

public extension View {
	/// Tracks the given environment value, calling a closure when it changes.
	func trackingEnvironment<Value>(
		_ key: KeyPath<EnvironmentValues, Value>,
		onChange: @escaping (Value) -> Void
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

