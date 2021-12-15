Extension { #name : #GtkWindowAdapter }

{ #category : #'*Spec-GtkBackendTests' }
GtkWindowAdapter >> windowIsResizable [

	^ self widgetDo: [ :w | w isResizable ]
]

{ #category : #'*Spec-GtkBackendTests' }
GtkWindowAdapter >> windowSize [

	^ self widgetDo: [ :w | w size ]
]
