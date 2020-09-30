import XCTest
import SwiftUI
@testable import SwiftUIMissingPieces

final class Tests: XCTestCase {
    func testTagged() {
		let test = TestIdentifiable(id: 42)
		let tagged = Tagged(test, with: "foo")
		XCTAssertEqual(test.id, tagged.id)
    }
	
	func testRemoveByID() {
		var texts = ["asdf", "hello!"]
			.map(TextHolder.init) // simple identifiable text holder
		let target = Array(texts.dropFirst())
		texts.removeByID(texts.first!)
		XCTAssertEqual(texts, target)
	}
	
	// TODO: test everything else lol
	// don't really know how to test the SwiftUI stuff, but I'm sure there's a way. PRs welcome ;)
}

struct TestIdentifiable: Identifiable {
	var id: Int
}
