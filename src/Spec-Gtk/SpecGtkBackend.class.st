Class {
	#name : 'SpecGtkBackend',
	#superclass : 'SpApplicationBackend',
	#category : 'Spec-Gtk-Base',
	#package : 'Spec-Gtk',
	#tag : 'Base'
}

{ #category : 'accessing' }
SpecGtkBackend class >> backendName [
	
	^ #Gtk
]

{ #category : 'private' }
SpecGtkBackend >> adapterBindingsClass [

	^ GtkAdapterBindings
]

{ #category : 'clipboard handling' }
SpecGtkBackend >> copyToClipboard: aString [

	GRunLoop defer: [
		GdkClipboard primary text: aString ]
]

{ #category : 'accessing' }
SpecGtkBackend >> defaultConfigurationFor: anApplication [

	^ anApplication defaultConfigurationForGtk
]

{ #category : 'accessing' }
SpecGtkBackend >> defer: aBlock [ 

	GRunLoop defer: aBlock
]

{ #category : 'accessing' }
SpecGtkBackend >> forceDefer: aBlock [ 

	GRunLoop forceDefer: aBlock
]

{ #category : 'initialization' }
SpecGtkBackend >> initialize [

	GtkEngine ensureRunning.
	super initialize
]

{ #category : 'private' }
SpecGtkBackend >> newFileDialogFor: aFileDialog [
	| dialog |

	dialog := GtkFileDialog new.
	aFileDialog title ifNotNil: [ :aString | dialog title: aString ].
	aFileDialog filters ifNotEmpty: [ :aList | 
		| filters |
		filters := GListStore newType: GtkFileFilter.
		aList do: [ :each |
			filters append: (GtkFileFilter new 
				addSuffix: each; 
				yourself) ].
		dialog filters: filters ].
	
	^ dialog
]

{ #category : 'ui - notifying' }
SpecGtkBackend >> notifyError: aSpecNotification [

	GtkErrorDialog runMessage: aSpecNotification message
]

{ #category : 'ui - notifying' }
SpecGtkBackend >> notifyInfo: aSpecNotification [

	GtkInformDialog runMessage: aSpecNotification message
]

{ #category : 'private' }
SpecGtkBackend >> openDialogSelector: aFileDialog [

	aFileDialog isSaveFile ifTrue: [ ^ #saveDo: ].
	aFileDialog isOpenDirectory ifTrue: [ ^ #selectFolderDo: ].
	
	^ #openDo:
]

{ #category : 'ui - dialogs' }
SpecGtkBackend >> openFileDialog: aFileDialog [
	| sem result selector |

	selector := self openDialogSelector: aFileDialog.
	sem := Semaphore new.
	GRunLoop defer: [ 
		(self newFileDialogFor: aFileDialog)
			perform: selector with: [ :file | 
				result := file.
				sem signal ] ].
	sem wait.
	^ result ifNotNil: [ result path asFileReference ]
]

{ #category : 'private' }
SpecGtkBackend >> setCursor: cursor toAll: aCollection [ 

	aCollection do: [ :each | 
			each adapter widget gdkWindow cursor: cursor ].
]

{ #category : 'ui' }
SpecGtkBackend >> showWaitCursorWhile: aBlock inApplication: anApplication [

	self forceDefer: [
		self setCursor: GdkCursor newWait toAll: anApplication windows ]. 
	aBlock ensure: [ 
		self forceDefer: [ 
			self setCursor: GdkCursor null toAll: anApplication windows ] ]
]
