"
A simple content for `SpGtkBannerPresenter`.
"
Class {
	#name : #SpGtkBannerContentPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'messageLabel',
		'closeButton',
		'showTime',
		'process'
	],
	#category : #'Spec-Gtk-Adapter-Window'
}

{ #category : #private }
SpGtkBannerContentPresenter class >> defaultShowTime [

	^ 5 seconds
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> beError [

	self addStyle: 'error'
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> beInformation [

	self addStyle: 'info'
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> beRequest [

	self addStyle: 'request'
]

{ #category : #layout }
SpGtkBannerContentPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		borderWidth: 3;
		add: messageLabel;
		add: closeButton expand: false;
		yourself
]

{ #category : #actions }
SpGtkBannerContentPresenter >> doClose [

	self owner remove: self
]

{ #category : #initialization }
SpGtkBannerContentPresenter >> initializePresenters [

	messageLabel := self newLabel.
	closeButton := self newButton
		addStyle: 'flat';
		addStyle: 'pill';
		"addStyle: 'circular';"
		icon: (GRunLoop defer: [ GtkImage newIconName: 'gtk-close' ]);
		action: [ self doClose ];
		yourself
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> message: aString [

	messageLabel label: aString
]

{ #category : #private }
SpGtkBannerContentPresenter >> schedule: aTaskOrBlock [

	process := aTaskOrBlock forkNamed: 'Banner'
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> showTime [

	^ showTime ifNil: [ self class defaultShowTime ]
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> showTime: aTime [

	showTime := aTime
]

{ #category : #accessing }
SpGtkBannerContentPresenter >> startTimer [

	self schedule: [
		self showTime wait.
		self doClose ]
]

{ #category : #private }
SpGtkBannerContentPresenter >> terminateTimerProcess [

	process ifNil: [ ^ self ].

	process terminate.
	process := nil
]
