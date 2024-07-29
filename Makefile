all:
	as -o g.o g.s
	ld -macos_version_min 14.0.0 -o g g.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

clean:
	rm g
	rm g.o 