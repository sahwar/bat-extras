#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# bat-extras | Copyright (C) 2019 eth-p | MIT License
#
# Repository: https://github.com/eth-p/bat-extras
# Issues:     https://github.com/eth-p/bat-extras/issues
# -----------------------------------------------------------------------------

# Printf, but with optional colors.
# This uses the same syntax and arguments as printf.
#
# Example:
#     printc "%{RED}This is red %s.%{CLEAR}\n" "text"
#
printc() {
	printf "$(sed "$_PRINTC_PATTERN" <<< "$1")" "${@:2}"
}

# Initializes the color tags for printc.
#
# Arguments:
#     color=on  -- Turns on color output.
#     color=off -- Turns off color output.
printc_init() {
	case "$1" in
		color=on) _PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI";;
		color=off) _PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN";;

		"") {
			_PRINTC_PATTERN_ANSI=""
			_PRINTC_PATTERN_PLAIN=""

			local name
			local ansi
			while read -r name ansi; do
				if [[ -z "${name}" && -z "${ansi}" ]] || [[ "${name:0:1}" = "#" ]]; then
					continue
				fi

				ansi="$(sed 's/\\/\\\\/' <<< "$ansi")"

				_PRINTC_PATTERN_PLAIN="${_PRINTC_PATTERN_PLAIN}s/%{${name}}//g;"
				_PRINTC_PATTERN_ANSI="${_PRINTC_PATTERN_ANSI}s/%{${name}}/${ansi}/g;"
			done

			if [ -t 1 ]; then
				_PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI"
			else
				_PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN"
			fi
		};;
	esac
}

# Initialization.
printc_init <<END
	CLEAR	\x1B[0m
	RED		\x1B[31m
	GREEN	\x1B[32m
	YELLOW	\x1B[33m
	BLUE	\x1B[34m
	MAGENTA	\x1B[35m
	CYAN	\x1B[36m

	DIM		\x1B[2m
END

