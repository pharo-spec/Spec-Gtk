Extension { #name : #SpApplication }

{ #category : #'*Spec-Gtk' }
SpApplication >> addCSSProviderFromPath: aPath [

	self ensureConfiguration addCSSProviderFromPath: aPath
]

{ #category : #'*Spec-Gtk' }
SpApplication >> addCSSProviderFromReference: aPath [

	self ensureConfiguration addCSSProviderFromReference: aPath
]

{ #category : #'*Spec-Gtk' }
SpApplication >> addCSSProviderFromString: aPath [

	self ensureConfiguration addCSSProviderFromString: aPath
]

{ #category : #'*Spec-Gtk' }
SpApplication >> defaultConfigurationForGtk [

	^ SpGtkConfiguration new
]

{ #category : #'*Spec-Gtk' }
SpApplication >> useTheme: aName [

	GRunLoop defer: [ self configuration installTheme: aName ]
]
