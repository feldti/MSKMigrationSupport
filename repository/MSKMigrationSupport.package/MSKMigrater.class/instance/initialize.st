initialize
initialize

	super initialize.

	self
		migrationFilename: self class defaultFilename ;
		candidateClasses: Array new ;
		migratorIndex: -1 ;
		fastMode: true ;
		migratorTotal: 0 ;
		migratorIndex: -1 ;
		transactionStepSize: 5000
