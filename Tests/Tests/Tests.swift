import XCTest
@testable import SwiftUI_Missing_Pieces

final class Tests: XCTestCase {
    func testTagged() {
		let test = TestIdentifiable(id: 42)
		let tagged = Tagged(test, with: "foo")
		XCTAssertEqual(test.id, tagged.id)
    }
	
	// TODO: test everything else lol
	// don't really know how to test the SwiftUI stuff, but I'm sure there's a way. PRs welcome ;)
}

struct TestIdentifiable: Identifiable {
	var id: Int
}
