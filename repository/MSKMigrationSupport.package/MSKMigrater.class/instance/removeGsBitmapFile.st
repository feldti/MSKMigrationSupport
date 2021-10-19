services - general
removeGsBitmapFile

	(GsFile existsOnServer: self migrationFilename)
		ifTrue:[
			(GsFile removeServerFile: self migrationFilename) isNil
				ifTrue:[ self error: 'Could not delete the temporary file <', self migrationFilename asString,'>' ].
		].
