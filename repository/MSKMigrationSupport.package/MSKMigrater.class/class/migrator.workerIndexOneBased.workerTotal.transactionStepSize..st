services
migrator: aFilenameOrNil workerIndexOneBased: workerIndex workerTotal: anInteger transactionStepSize: stepSizeIntegerOrNil

	| newInstance |

	newInstance := self new initialize.
	
	newInstance 
		migrationFilename:  (aFilenameOrNil isNil ifTrue:[ self defaultFilename ] ifFalse:[ aFilenameOrNil ]) ;
		migratorTotal: anInteger ;
		migratorIndex: workerIndex ;
		transactionStepSize: (stepSizeIntegerOrNil isNil ifTrue:[ 5000 ] ifFalse:[ stepSizeIntegerOrNil ]).

	^newInstance
