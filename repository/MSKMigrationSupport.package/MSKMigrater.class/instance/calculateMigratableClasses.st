services - collector
calculateMigratableClasses
	"^<Array of: Class> Calculates candidates for migration. Classes with a class history size of at least 2"
	| candidateClassesWithHistories historicalClasses   |


	"from the list of candidate classes we consider only the classes with a class history"
	candidateClassesWithHistories := self candidateClasses select:[ :eachClass | eachClass  classHistory size > 1 ].

	"
	Now perhaps the stuff, which is not clear in the documentation. If you want to migrate instances you normally
	migrate them to the current class version. So you have to look for instances belonging to OLDER versions than
	current class version. In the next lines of code we look for all historical classes and add them to the classes to
	consider. The current class version is NOT in the result list.
	In all classes found we set the migration target class  and commit the result.
	"
	historicalClasses := Array new.
	candidateClassesWithHistories do:[ :eachClass |
		(eachClass  classHistory copyFrom: 1 to: eachClass  classHistory size - 1)
			do: [ :singleClass |
				historicalClasses add: singleClass
			]
	].	

	"no classes, no migration needed"
	^historicalClasses
