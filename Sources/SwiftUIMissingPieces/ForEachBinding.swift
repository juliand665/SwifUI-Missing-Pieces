import SwiftUI

/// Like `ForEach`, but takes a mutable collection and gives you `Binding`s so you can mutate the view contents. 
public struct ForEachBinding<Collection, LoopBody>: View, DynamicViewContent where
	Collection: MutableCollection,
	Collection.Element: Identifiable,
	Collection.Index: Hashable,
	LoopBody: View
{
	public typealias Element = Collection.Element
	typealias Index = Collection.Index
	
	@Binding public var data: Collection
	let loopBody: (Binding<Element>) -> LoopBody
	
	/**
	Creates an instance that computes views for each collection element using the given view builder.
	
	- Parameters:
		- data: The data source to display and bind to.
		- loopBody: The view builder to construct the dynamic views from.
		- element: A binding to the element for which to build a view.
	*/
	public init(
		_ data: Binding<Collection>,
		@ViewBuilder loopBody: @escaping (_ element: Binding<Element>) -> LoopBody // a typealias for the closure would be more opaque in the docs and autocomplete
	) {
		self._data = data
		self.loopBody = loopBody
	}
	
	public var body: some View {
		// Using the data's id rather than involving the index makes animations work correctly.
		ForEach(zip(data, data.indices).map(Tagged.init)) { tagged -> LoopBody in
			loopBody($data.workaround[tagged.tag])
		}
	}
}

// TODO: make this public? might be nice if there's demand for it and Apple don't fix it…

extension Binding {
	/// Works around a weird quirk with vanilla binding keypath accesses causing index-based bindings to try to update their value, which fails if the index is now out of range, even if you don't need that binding anymore.
	var workaround: BindingWorkaroundConstructor<Value> { .init(self) }
}

@dynamicMemberLookup
struct BindingWorkaroundConstructor<Value> {
	@Binding private var value: Value
	
	init(_ wrapped: Binding<Value>) {
		self._value = wrapped
	}
	
	subscript<T>(dynamicMember path: WritableKeyPath<Value, T>) -> Binding<T> {
		Binding { value[keyPath: path] }
			set: { value[keyPath: path] = $0 }
	}
}
