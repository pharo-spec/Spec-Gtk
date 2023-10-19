Extension { #name : 'SpApplication' }

{ #category : '*Spec-Gtk-Code' }
SpApplication >> styleScheme [
	
	^ self ensureConfiguration styleScheme
]

{ #category : '*Spec-Gtk-Code' }
SpApplication >> syntaxHighlightTheme [
	
	^ self ensureConfiguration syntaxHighlightTheme
]
