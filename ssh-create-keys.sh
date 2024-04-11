#!/bin/bash
#
# Copyright 2024 The ssh-create-keys script Contributors
# SPDX-License-Identifier: MIT
#

# Required tools list
required_tools=(date openssl ssh-keygen awk cut xxd)

# Checking the availability of tools
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "Error: The tool $tool is not installed on this system."
        exit 1
    fi
done

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

# Default variable initialization
current_date=$(date -I)
algorithm="ed25519"
comment="$current_date" 

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

# Generating the passphrase for the private key
base64Password=$(openssl rand -base64 33)

# Creating SSH key pair
# echo "Generating public/private $algorithm key pair..."
ssh-keygen -q -t "$algorithm" -f "$temp_dir/$privateKeyFileName" -N "$base64Password" -C "$comment"

# Extracting the fingerprint
fullFingerprint=$(ssh-keygen -lf "$temp_dir/$privateKeyFileName" -E sha256)

# Extracting the first 8 characters of the fingerprint converted to hexadecimal
base64Fingerprint=$(echo "$fullFingerprint" | cut -d ':' -f 2 | awk '{print $1}')
hexFingerprint=$(echo "$base64Fingerprint=" | base64 -d | xxd -p -c 32)
shortFingerprint=$(echo "$hexFingerprint" | cut -c 1-8)

# Creating output file names
outPrivateKeyFileName=$(echo "$privateKeyFileName"_"$current_date"_"$shortFingerprint")
outPublicKeyFileName="$outPrivateKeyFileName.pub"

# Displaying the SHA-256 fingerprint of the key
echo "The key fingerprint is:"
echo "$fullFingerprint"
echo

# Displaying the passphrase
echo "Your private key passphrase is:"
echo "$base64Password"
echo

# Calling the function to calculate and displaying entropy
calculate_entropy "$base64Password"
echo

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
