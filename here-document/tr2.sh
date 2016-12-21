#!/bin/bash

# Appending a minus sign to the << has the effect that leading tabs are ignored
tr a-z A-Z <<- END_TEXT
	one two three
	four five six
	END_TEXT
