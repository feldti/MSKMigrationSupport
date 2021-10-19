services - migrator
migrate
	| fileInfo totalOOpsWritten oopsForEachTask currentIndex  limit maxIndex transactionSize |

	self log: 'Start migrating instances'.

	fileInfo := self fileInfo.
	totalOOpsWritten := fileInfo first.
	
	"
		totalOOpsWritten = 100
		migratorTotal = 8,

		oopsForEachTask = 12

		migratorIndex = 1, migratorIndex = 2, migratorIndex = 8
		limit             = 12, 12, ...., 16
        currentIndex  = 1, 13, ..., 85
        maxIndex      =  1 + 12 - 1(12), 13 + 12 - 1 (24), ..., 85 + 16 - 1 (100)
	"
	oopsForEachTask := (totalOOpsWritten / self migratorTotal) truncated.

	limit := 
		(migratorTotal = self migratorIndex)
		ifTrue:[ totalOOpsWritten - (oopsForEachTask * (self migratorIndex - 1)) ]
		ifFalse:[ oopsForEachTask ].

	currentIndex := 1 + (oopsForEachTask * (self migratorIndex - 1)).
	maxIndex := currentIndex + limit - 1.

	transactionSize := self transactionStepSize.
	System abortTransaction.
	limit > 0
		ifTrue:[
			[ currentIndex  <=  maxIndex  ] whileTrue:  [
				| bm stepSize objectRead |
				System inTransaction ifFalse:[ System beginTransaction ].
				stepSize :=  (maxIndex - currentIndex + 1) min: transactionSize.
				bm  :=  GsBitmap  new.
				objectRead := bm  readFromFile:  self migrationFilename withLimit: stepSize startingAt:  currentIndex.
				bm  do:  [:ea  |  ea class ~= ea class currentVersion ifTrue:[ ea migrate ] ].  			
				System  commitTransaction
					ifTrue:[
						self log:  'Progress ',currentIndex asString ,' of ', maxIndex asString,'. #Items: ',objectRead asString.
						transactionSize := (transactionSize * 2) min: 20000.
						currentIndex  :=  currentIndex  +  stepSize.					
					]
					ifFalse:  [
						transactionSize := (transactionSize / 2) truncated max: 1.
						System abortTransaction.
						self log:  'Retry ',currentIndex asString ,' of ', maxIndex asString,'. #Items: ',objectRead asString.
					].
			]
		].

	self log: 'Finished migrating instances'.
