services
collector: aFilenameOrNil classes: classCollection fastMode: aBoolean

	| newInstance |

	newInstance := self new initialize.
	
	newInstance 
		migrationFilename:  (aFilenameOrNil isNil ifTrue:[ self defaultFilename ] ifFalse:[ aFilenameOrNil ]) ;
		candidateClasses: classCollection ;
		fastMode: aBoolean.

	^newInstance
