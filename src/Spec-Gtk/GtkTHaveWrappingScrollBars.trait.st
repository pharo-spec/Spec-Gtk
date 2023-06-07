Trait {
	#name : #GtkTHaveWrappingScrollBars,
	#instVars : [
		'innerWidget'
	],
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #'private - accessing' }
GtkTHaveWrappingScrollBars >> innerWidget [
	
	^ innerWidget
]

{ #category : #building }
GtkTHaveWrappingScrollBars >> wrapWidget: gtkWidget [
	| wrapWidget |

	innerWidget := gtkWidget.
	self model hasScrollBars ifFalse: [ ^ super wrapWidget: gtkWidget ].
	wrapWidget := self wrapWithScrollableWindow: innerWidget.
	
	wrapWidget 
		propagateNaturalWidth: self presenter isPropagateNaturalWidth;
		propagateNaturalHeight: self presenter isPropagateNaturalHeight.
		
	self presenter scrollBarStyles ifNotNil: [ :styles |
		styles do: [ :each | wrapWidget addClass: each ] ].
	
	^ wrapWidget
]
