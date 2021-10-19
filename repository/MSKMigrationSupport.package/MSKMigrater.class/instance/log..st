services - logging
log: aString

	GsFile gciLogServer:  ((ReadStream on: DateAndTime now asString) upTo: $.),' - ',aString
