"
A presenter to create a banner, an information area that will be displayed on top of a window. 
This simulates AdwBanner from libadwaita (https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/class.Banner.html), which is at its time the replacement for GtkInfoBar, but the api will not be the same. 
We will add any component, but they need to take into account this is intended to be a simple text with (maybe) some operations.
"
Class {
	#name : #SpGtkBannerPresenter,
	#superclass : #SpPresenter,
	#category : #'Spec-Gtk-Adapter-Window'
}

{ #category : #accessing }
SpGtkBannerPresenter >> add: aContentPresenter [

	self layout
		add: aContentPresenter
		expand: false.
	aContentPresenter startTimer
]

{ #category : #accessing }
SpGtkBannerPresenter >> addError: aString [

	self add: ((self instantiate: SpGtkBannerContentPresenter)
		beError;
		message: aString;
		yourself)
]

{ #category : #accessing }
SpGtkBannerPresenter >> addInfo: aString [

	self add: ((self instantiate: SpGtkBannerContentPresenter)
		beInformation;
		message: aString;
		yourself)
]

{ #category : #layout }
SpGtkBannerPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : #initialization }
SpGtkBannerPresenter >> initializePresenters [

	self addStyle: 'banner'
]

{ #category : #accessing }
SpGtkBannerPresenter >> remove: aContentPresenter [

	self layout remove: aContentPresenter
]
