Extension { #name : 'GtkBaseWindowAdapter' }

{ #category : '*Spec-GtkBackendTests' }
GtkBaseWindowAdapter >> windowIsResizable [

	^ self widgetDo: [ :w | w isResizable ]
]

{ #category : '*Spec-GtkBackendTests' }
GtkBaseWindowAdapter >> windowSize [

	^ self widgetDo: [ :w | w defaultSize ]
]
