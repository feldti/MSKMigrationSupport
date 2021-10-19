services-fileouts
fileOutClasses: order in: aPathName 
	"^<Boolean> Returns true, if the fileout was a success

		MSKMigrater fileOutClasses: CATIGeneralAddress subclasses asArray in: 'test3.gs'.
	"

	| aGsFile success aSymbolDictionary |

	success := false.
	(aGsFile := GsFile openWriteOnServer: aPathName) isNil
		ifTrue:[ self halt: 'Classes could ot be written into a file' ].

	aSymbolDictionary := SymbolDictionary new.

	CATIGeneralAddress subclasses do: [ :eachClass |
		aSymbolDictionary at: eachClass name put: eachClass].

	[
		ClassOrganizer new
			fileOutClassesAndMethodsInDictionary: aSymbolDictionary  on: aGsFile.
		success := true.
	]
	ensure: [ aGsFile close ].

	^success
