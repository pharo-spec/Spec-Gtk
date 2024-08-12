Extension { #name : 'SpDiffPresenter' }

{ #category : '*Spec-Gtk-Code-Diff' }
SpDiffPresenter class >> defaultMarks [
	
	^ {  
		(SpPatchMark newName: #insert) 
			backgroundColor: (Color green alpha: 0.1); 
			iconName: #changeAdd;
			yourself.
		(SpPatchMark newName: #delete)
			backgroundColor: (Color red alpha: 0.1);
			iconName: #changeRemove;
			yourself.
		(SpPatchMark newName: #change)
			backgroundColor: (Color gray alpha: 0.1);
			iconName: #changeUpdate;
			yourself.
	}
]

{ #category : '*Spec-Gtk-Code-Diff' }
SpDiffPresenter >> marks [
	
	^ self class defaultMarks
		collect: [ :aMark | aMark name -> aMark ]
		as: SmallDictionary
]
