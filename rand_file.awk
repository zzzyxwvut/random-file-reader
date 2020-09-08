#!/usr/bin/gawk -f
#
# "Gawk is multibyte aware. This means that index(), length(), substr() and
# match() all work in terms of characters, not bytes." (See gawk(1).)

# Obtains current "real estate" of a terminal.
function estate(holder,		_size, _command, _position)
{
	_command = "(/bin/stty size)"
	_command | getline _size
	close(_command)

	_position = index(_size, " ")
	holder["rows"] = 0 + substr(_size, 1, _position)
	holder["cols"] = 0 + substr(_size, _position + 1)
}

# Erases the whole display and moves cursor to origin at 1,1.
function clear()
{
	system("")			# Flush pending output.
	printf("\033[2J\033[H")		# See console_codes(4).
}

# Echoes the passed line, redrawing screen after the bottom row.
#
# Note that there must be no embedded newlines in the passed line: split
# any line before a newline and pass every newline character separately as
# an empty string.  E.g. substitute
#	echo("")
#	echo("foo")
#	echo("")
#	echo("")
#	echo("bar")
#	echo("")
# for
#	echo("\nfoo\n\nbar\n")
function echo(line,		_head, _tail)
{
	_head = line
	_tail = line

	do {
		# Account for lines longer than the screen column number.
		_head = substr(_tail, 1, cols)
		_tail = substr(_tail, cols + 1)

		if (offset < 2) {
			offset = rows
			printf("%s", _head)	# Beware of %... input.
####			system("/bin/sleep 0.032768") # See phosphor -delay...
			clear()
		} else {
			--offset
			printf("%s", _head)	# Beware of %... input.
		}
	} while (_tail != "")

	if (offset != rows)
		print("")	# Do not advance cursor below the last row.
}

BEGIN {
	if (ARGC < 2) {
		print("Usage: rand_file.awk file1 [file2 ...]") > "/dev/stderr"
		exit(1)
	}

	clear()
	estate(limits)
	rows = limits["rows"]
	cols = limits["cols"]
	delete limits

	# Select a random filename-argument.
	srand()
	filename = ARGV[int((ARGC - 1) * rand() + 1)]
	lineno = 0			# NR remains 0 in a BEGIN rule.
	offset = rows
	echo(sprintf("/* %s */", filename))
	echo("")

	while ((status = getline < filename) > 0) {
		echo($0)
		++lineno
	}

	if (status) {
		printf("Failure (%d): %s\n", status, ERRNO) > "/dev/stderr"
		exit(1)
	}

	echo("")
	echo(sprintf("/* %s [%d lines] */", filename, lineno))
	close(filename)
}
