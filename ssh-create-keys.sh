#!/bin/bash
#
# Copyright 2024 The ssh-create-keys script Contributors
# SPDX-License-Identifier: MIT
#

# Required tools list
required_tools=(date openssl ssh-keygen awk cut xxd sed)

# Checking the availability of tools
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "Error: The tool $tool is not installed on this system."
        exit 1
    fi
done

die()
{
    local _ret="${2:-1}"
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo "$1" >&2
    exit "${_ret}"
}

evaluate_strictness()
{
    [[ "$2" =~ ^--?[a-zA-Z] ]] && die "You have passed '$2' as a value of argument '$1'. It looks like that you are trying to pass an option instead of the actual value, which is considered a fatal error."
}

# validators
nnint()
{
    printf "%s" "$1" | grep -q '^\s*+\?[0-9]\+\s*$' || die "The value of argument '$2' is '$1', which is not a non-negative integer."
    printf "%d" "$1"
}

begins_with_short_option()
{
    local first_option all_short_options='vfpCPaVh'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
version="devel"
_arg_verbose="off"
_arg_create_files="off"
_arg_print="off"
_arg_comment=
_arg_passphrase=
_arg_rounds="16"

print_help()
{
    printf '%s\n' "Passphrase and public/private ed25519 key pair generator."
    printf 'Usage: %s [-v|--(no-)verbose] [-f|--(no-)create-files] [-p|--(no-)print] [-C|--comment <string>] [-P|--passphrase <string>] [-a|--rounds <integer>] [-V|--version] [-h|--help]\n' "$0"
    printf '\t%s\n' "-v, --verbose, --no-verbose: Verbose mode (off by default)"
    printf '\t%s\n' "-f, --create-files, --no-create-files: Create files in current folder (off by default)"
    printf '\t%s\n' "-p, --print, --no-print: print private-public key on terminial (off by default)"
    printf '\t%s\n' "-C, --comment: custom comment (default: 'AAAA-MM-JJTHH:MM:SSZ')"
    printf '\t%s\n' "-P, --passphrase: custom passphrase (no default)"
    printf '\t%s\n' "-a, --rounds: KDF rounds (default: '16')"
    printf '\t%s\n' "-V, --version: Prints version"
    printf '\t%s\n' "-h, --help: Prints help"
}

parse_commandline()
{
    while test $# -gt 0
    do
        _key="$1"
        case "$_key" in
            -v|--no-verbose|--verbose)
                _arg_verbose="on"
                test "${1:0:5}" = "--no-" && _arg_verbose="off"
                ;;
            -v*)
                _arg_verbose="on"
                _next="${_key##-v}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -f|--no-create-files|--create-files)
                _arg_create_files="on"
                test "${1:0:5}" = "--no-" && _arg_create_files="off"
                ;;
            -f*)
                _arg_create_files="on"
                _next="${_key##-f}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-f" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -p|--no-print|--print)
                _arg_print="on"
                test "${1:0:5}" = "--no-" && _arg_print="off"
                ;;
            -p*)
                _arg_print="on"
                _next="${_key##-p}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-p" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -C|--comment)
                test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                _arg_comment="$2" || exit 1
                shift
                evaluate_strictness "$_key" "$_arg_comment"
                ;;
            -C*)
                _arg_comment="${_key##-C}" || exit 1
                evaluate_strictness "$_key" "$_arg_comment"
                ;;
            -P|--passphrase)
                test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                _arg_passphrase="$2" || exit 1
                shift
                evaluate_strictness "$_key" "$_arg_passphrase"
                ;;
            -P*)
                _arg_passphrase="${_key##-P}" || exit 1
                evaluate_strictness "$_key" "$_arg_passphrase"
                ;;
            -a|--rounds)
                test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                _arg_rounds="$(nnint "$2" "rounds")" || exit 1
                shift
                evaluate_strictness "$_key" "$_arg_rounds"
                ;;
            -a*)
                _arg_rounds="$(nnint "${_key##-a}" "rounds")" || exit 1
                evaluate_strictness "$_key" "$_arg_rounds"
                ;;
            -V|--version)
                echo $version
                exit 0
                ;;
            -V*)
                echo $version
                exit 0
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            -h*)
                print_help
                exit 0
                ;;
            *)
                _PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
                ;;
        esac
        shift
    done
}

# Function to clean up the temporary directory
clean_temp_dir() {
    rm -rf "$temp_dir"
    exit 0
}

# Calling the function to calculate Shannon entropy for the passphrase and displaying the result
calculate_entropy() {
    local input=$1
    local length=${#input}
    declare -A frequency

    # Calculating the frequency of characters
    for (( i=0; i<length; i++ )); do
        char="${input:$i:1}"
        (( frequency[$char]++ ))
    done

    # Calculating entropy
    entropy=0
    for char in "${!frequency[@]}"; do
        probability=$(bc -l <<< "scale=10; ${frequency[$char]} / $length")
        entropy=$(bc -l <<< "$entropy - ($probability * l($probability)/l(2))")
    done

    # Displaying the result
    totalEntropy=$(bc -l <<< "$entropy * $length")
    echo "The passphrase consists of $length symbols, with ${#frequency[@]} unique symbols. "
    echo "It has an entropy of approximately $(printf "%.0f" $totalEntropy) bits, or $(printf "%.2f" $entropy) bits per symbol. "

}

# Print keys in the terminal
print_terminal()
{
    # Displaying the private key
    echo "To save your private key with filename ./$outPrivateKeyFileName,"
    echo "run the following command to create a file in the current directory:"
    echo
    echo "echo \"$(cat "$temp_dir/$privateKeyFileName")\"\\"
    echo "> ./$outPrivateKeyFileName"
    echo
    echo
    # Displaying the public key
    echo "To save your public key with filename ./$outPublicKeyFileName",
    echo "run the following command to create a file in the current directory:"
    echo
    echo "echo \"$(cat "$temp_dir/$publicKeyFileName")\"\\"
    echo "> ./$outPublicKeyFileName"
}

# Save keys in current folder
create_files()
{
    current_directory="$PWD"
    echo "$_arg_passphrase" > "$current_directory/$outPrivateKeyFileName.secret"
    cp "$temp_dir/$privateKeyFileName" "$current_directory/$outPrivateKeyFileName"
    cp "$temp_dir/$publicKeyFileName" "$current_directory/$outPublicKeyFileName"
    echo "3 files created in $PWD"
}

# Parse command line options
parse_commandline "$@"

# Default variable initialization
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
algorithm="ed25519"

# If comment is not set, use default comment
if [ -z "$_arg_comment" ]; then
    _arg_comment="$current_date"
else
    _arg_comment="$_arg_comment - $current_date"
fi

# Create a temporary directory
temp_dir=$(mktemp -d)

# Signal handler to intercept termination signals
trap 'clean_temp_dir' EXIT INT

# Modify permissions of the temporary directory
chmod 700 $temp_dir

privateKeyFileName="id_$algorithm"
publicKeyFileName="$privateKeyFileName.pub"

echo "Generating passphrase and public/private $algorithm key pair..."
echo

# If passphrase is not set, generate the passphrase for the private key
if [ -z "$_arg_passphrase" ]; then
    _arg_passphrase=$(openssl rand -base64 33)
fi

# Creating SSH key pair
# echo "Generating public/private $algorithm key pair..."
ssh-keygen -q -t "$algorithm" -a "$_arg_rounds" -f "$temp_dir/$privateKeyFileName" -N "$_arg_passphrase" -C "$_arg_comment"

# Extracting the fingerprint
fullFingerprint=$(ssh-keygen -lf "$temp_dir/$privateKeyFileName" -E sha256)

# Extracting the first 8 characters of the fingerprint converted to hexadecimal
base64Fingerprint=$(echo "$fullFingerprint" | cut -d ':' -f 2 | awk '{print $1}')
hexFingerprint=$(echo "$base64Fingerprint=" | base64 -d | xxd -p -c 32)
shortFingerprint=$(echo "$hexFingerprint" | cut -c 1-8)

# Creating output file names
outPrivateKeyFileName=$(echo "$privateKeyFileName"_$(echo "$current_date" | sed 's/:/-/g')_"$shortFingerprint")
outPublicKeyFileName="$outPrivateKeyFileName.pub"

# Displaying the SHA-256 fingerprint of the key
echo "The key fingerprint is:"
echo "$fullFingerprint"
echo

# Displaying the passphrase
echo "Your private key passphrase, encoded with $_arg_rounds KDF rounds, is:"
echo "$_arg_passphrase"
echo

# Calling the function to calculate and displaying entropy
calculate_entropy "$_arg_passphrase"
echo

if [ "$_arg_print" = "on" ]; then
    print_terminal
fi

if [ "$_arg_create_files" = "on" ]; then
    create_files
fi
