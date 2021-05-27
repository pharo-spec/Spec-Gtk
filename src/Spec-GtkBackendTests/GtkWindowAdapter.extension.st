Extension { #name : #GtkWindowAdapter }

{ #category : #'*Spec-GtkBackendTests' }
GtkWindowAdapter >> windowSize [

	^ self widgetDo: [ :w | w size ]
]
