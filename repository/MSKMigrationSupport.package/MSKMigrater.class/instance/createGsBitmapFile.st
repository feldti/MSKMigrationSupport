services - collector
createGsBitmapFile
	"^<Integer> Number of migratable instances> Start the collector action. Scans the whole extent for objects to be migrated"
	|  historicalClasses largeBitmap arrayOfResults return |

	self log: 'Starting building GsBitmap structure'.

	"First we remove the old temp. file for storing the result"
	self removeGsBitmapFile.

	(historicalClasses := self calculateMigratableClasses) isEmpty
		ifTrue:[ 
			self log: 'No migratable classes found. Exit'.
			^0 ].

	historicalClasses do: [ :singleClass | singleClass  migrateTo: singleClass currentVersion ].

	System commitTransaction.
	largeBitmap := GsBitmap  new.

	self log: 'Starting scanning - that may take time'.
	arrayOfResults  :=  self fastMode ifTrue:[ SystemRepository  fastAllInstances:  historicalClasses ] ifFalse:[ SystemRepository  allInstances:  historicalClasses ].
	self log: 'Finished scanning'.

	"For each class we get an instance of GsBitmap. We put them together in ONE large GsBitmap."
	arrayOfResults do: [ :eachSubArray |
		| aClass aGsBitmap |
		aClass := eachSubArray first.
		aGsBitmap := eachSubArray last.
		self log: '#Instances found for class named: ', aClass name asString,' -> ',aGsBitmap size asString.
		aGsBitmap size > 0
			ifTrue: [
				largeBitmap := largeBitmap union: aGsBitmap.
			]
	].
 
	"3.4.0 throws an exception in case of an empty GsBitmap"
	return := 
		(largeBitmap size = 0)
			ifTrue:[ 
				self log: 'No migratable instances found. Exit'.
				0 ]
			ifFalse:[
				"We store them in the temporary file"
				largeBitmap  writeToFileInPageOrder: self migrationFilename
			].

	self log: 'Finished building GsBitmap structure. OOPs stored: ',return asString,' in ',self migrationFilename,' located in ',GsFile serverCurrentDirectory.
	^return
