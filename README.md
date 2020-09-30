# SwiftUI Missing Pieces

Provides several little pieces SwiftUI is currently lacking to improve ergonomics and simplify common tasks.

All parts are described below, but these are my favorites:

- `in`: transforms a view using a closure, while keeping the nice modifier syntax and avoiding `AnyView`
- `EnvironmentTracker`: tracks and notifies of changes to `@Environment` values (e.g. the color scheme)
- `ForEachBinding`: An upgrade to `ForEach` that provides you with full-fledged bindings to the values in the body.

## Parts & Examples

All these examples fully compile as part of the test suite.

### EnvironmentTracker

Takes an environment value key path (like `@Environment`) and lets you track it for changes (internally using preferences, not polling or something).

```swift
Text("asdf")
	.trackingEnvironment(\.colorScheme) {
		switch $0 {
		case .dark:
			print("dark color scheme!")
		case .light:
			print("light color scheme!")
		@unknown default:
			print("unknown color scheme…")
		}
	}
```

### ForEachBinding

Works just like `ForEach`, except that the body view builder is provided not just the value but a binding to the element in question, easily letting you mutate it.

```swift
@State var texts = ["asdf", "hello!"]
	.map(TextHolder.init) // simple identifiable text holder

var body: some View {
	ForEachBinding($texts) { textBinding in
		VStack {
			// Unfortunately we don't get nice property wrapper syntax sugar, but it works just fine.
			TextField("text", text: textBinding.text)
			Text("\(textBinding.wrappedValue.text.count) characters")
		}
	}
}
```

### removeByID

Removes all elements (usually at most one) from a collection with the same ID as the given one. Very handy for e.g. adding a delete button/action for an element in a `ForEach` body.

```swift
var texts = ["asdf", "hello!"]
	.map(TextHolder.init) // simple identifiable text holder
texts.removeByID(texts.first!)
// texts is now just [TextHolder("hello!")]
```

### SimplePreferenceKey

Provides the "obvious" implementation of a preference key with an optional value, nil-coalescing for `reduce`. There is a nominal generic parameter `Marker`, allowing coexistence of multiple keys with the same value type.

```swift
private enum WidthMarker {}
typealias WidthKey = SimplePreferenceKey<WidthMarker, CGFloat>

var body: some View {
	Text("example")
		.background(GeometryReader { proxy in
			Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
		})
		.onPreferenceChange(WidthKey.self) { print("text width changed to \($0!)!") }
}
```

### Tagged

Lets you easily associate a tag with a value while keeping the value's ID. Useful for passing down additional info while keeping correct `Identifiable` conformance.

```swift
@State var texts = ["asdf", "hello!"]
	.map(TextHolder.init) // simple identifiable text holder

var body: some View {
	ForEach(zip(texts, texts.indices).map(Tagged.init)) { tagged in
		Text("\(tagged.value.text) (at \(tagged.tag)")
	}
}
```

### in

Applies the given closure to a view and returns the result. Makes for a nice easy way to apply conditional (e.g. platform-specific) modifiers.

```swift
Text("example")
	.in {
		if shouldHide { $0.hidden() } else { $0 }
	}
	.in {
		#if os(macOS)
		$0.presentedWindowStyle(TitleBarWindowStyle())
		#else
		$0.indexViewStyle(PageIndexViewStyle())
		#endif
	}
```

### hoverState

Tracks whether a view is hovered or not, updating the given binding accordingly.

```swift
@State var isHovered = false

Text(isHovered ? "thanks!" : "hover over me :)")
	.hoverState($isHovered)
```

### measured

Measures a view after layout, updating you when its size changes.

```swift
@State var textWidth: CGFloat = 0

VStack {
	Text("Measure me!")
		.measured { textWidth = $0.width }
	
	Text("The above text is \(textWidth) points wide.")
}
```

