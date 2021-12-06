Extension { #name : #PluggableMenuSpec }

{ #category : #'*Spec-Gtk-Morphic-Adapter' }
PluggableMenuSpec >> asMenuBarPresenter [
	
	^ SpMenuBarPresenter new
		addGroup: [ :group |
			self items do: [ :each |
				group addMenuItem: each asMenuItemPresenter ] ]
]

{ #category : #'*Spec-Gtk-Morphic-Adapter' }
PluggableMenuSpec >> asMenuPresenter [
	| presenter |

	presenter := SpMenuPresenter new.
	(self items groupByRuns: [ :each | each separator = true ]) do: [ :eachGroup |
		presenter addGroup: [ :group |
			eachGroup do: [  :each |
				group addMenuItem: each asMenuItemPresenter ] ] ].
	^ presenter
]
