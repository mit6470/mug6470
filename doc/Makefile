all : favicon logo

favicon :
	inkscape -C -e favicon.png -h 16 -w 16 favicon.svg
	convert favicon.png favicon.ico
	mv favicon.ico ../public

logo :
	# Specify width and height arguments by adding the "-w <width>" and/or
	# "-h <height>" arguments (as above).
	inkscape -C -e logo.png logo.svg
