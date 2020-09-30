import SwiftUI

/**
Provides the "obvious" implementation of a preference key with an optional value, nil-coalescing for `reduce`.

The generic parameter `Marker` is only nominal, allowing coexistence of multiple keys with the same value type.

Example usage:
```
private enum WidthMarker {}
typealias WidthKey = SimplePreferenceKey<WidthMarker, CGFloat>
```
*/
public enum SimplePreferenceKey<Marker, Value>: PreferenceKey {
	public static var defaultValue: Value? { nil }
	
	public static func reduce(value: inout Value?, nextValue: () -> Value?) {
		value = value ?? nextValue()
	}
}
