import XCTest
import SwiftUI
@testable import SwiftUIMissingPieces

// In this file, we really just test that stuff compiles. These are also the examples in the readme.

struct EnvironmentTrackerTest: View {
	var body: some View {
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
	}
}

struct TextHolder: Identifiable, Hashable {
	let id = UUID()
	var text: String
}

struct ForEachBindingTest: View {
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
}

private enum WidthMarker {}
private typealias WidthKey = SimplePreferenceKey<WidthMarker, CGFloat>

struct SimplePreferenceKeyTest: View {
	var body: some View {
		Text("example")
			.background(GeometryReader { proxy in
				Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
			})
			.onPreferenceChange(WidthKey.self) { print("text width changed to \($0!)!") }
	}
}

struct TaggedTest: View {
	@State var texts = ["asdf", "hello!"]
		.map(TextHolder.init) // simple identifiable text holder
	
	var body: some View {
		ForEach(zip(texts, texts.indices).map(Tagged.init)) { tagged in
			Text("\(tagged.value.text) (at \(tagged.tag)")
		}
	}
}

// the best platform-specific examples i found aren't available on older versions
@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
struct InExample: View {
	var body: some View {
		Text("example")
			.in {
				#if os(macOS)
				$0.presentedWindowStyle(TitleBarWindowStyle())
				#else
				$0.indexViewStyle(PageIndexViewStyle())
				#endif
			}
	}
}

struct IfExample: View {
	@State var shouldHide = false
	
	var body: some View {
		Text("example")
			.if(shouldHide) { $0.hidden() }
	}
}

@available(iOS 13.4, *)
struct HoverStateTest: View {
	@State var isHovered = false
	
	var body: some View {
		Text(isHovered ? "thanks!" : "hover over me :)")
			.hoverState($isHovered)
	}
}

struct MeasuredTest: View {
	@State var textWidth: CGFloat = 0
	
	var body: some View {
		VStack {
			Text("Measure me!")
				.measured { textWidth = $0.width }
			
			Text("The above text is \(textWidth) points wide.")
		}
	}
}
