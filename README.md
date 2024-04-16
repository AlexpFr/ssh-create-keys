# SSH Key Pair Generator

This script automates the process of generating a passphrase-protected SSH key pair using the Ed25519 algorithm.  
It simplifies the generation of keys and displays necessary information for saving and using the keys.

## Usage

Recommended filename for the script: `ssh-create-keys.sh`.

Make sure you have the required tools installed:

- `date`
- `openssl`
- `ssh-keygen`
- `awk`
- `cut`
- `xxd`
- `sed`

Run `chmod 755 ssh-create-keys.sh` to make the script executable.  

```
~/ssh-create-keys$ ./ssh-create-keys.sh --help
Passphrase and public/private ed25519 key pair generator.
Usage: ./ssh-create-keys.sh [-v|--verbose] [-f|--(no-)create-files] [-p|--(no-)print] [-C|--comment <string>] [-P|--passphrase <string>] [-a|--rounds <integer>] [-V|--version] [-h|--help]
        -v, --verbose: Verbose mode, you can repeat this 2 times (0 by default)
        -f, --create-files, --no-create-files: Create files in current folder (off by default)
        -p, --print, --no-print: print private-public key on terminial (off by default)
        -C, --comment: custom comment (default: 'AAAA-MM-JJTHH:MM:SSZ')
        -P, --passphrase: custom passphrase (no default)
        -a, --rounds: KDF rounds (default: '16')
        -V, --version: Prints version
        -h, --help: Prints help
```

## Example Output

```
~/ssh-create-keys$ ./ssh-create-keys.sh -fpvv
Generating passphrase and public/private ed25519 key pair...

The key fingerprint is:
256 SHA256:<fingerprint> AAAA-MM-JJTHH:MM:SSZ (ED25519)

Your private key passphrase is:
<passphrase>

The passphrase consists of xx symbols, with xx unique symbols. 
It has an entropy of approximately xxx bits, or x.xx bits per symbol.

To save your private/public keys with filenames ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint> and ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>.pub,
run the following command to create a file in the current directory:

echo "-----BEGIN OPENSSH PRIVATE KEY-----
<armored private key data>
-----END OPENSSH PRIVATE KEY-----"\
> ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>


echo "ssh-ed25519 <armored public key data> AAAA-MM-JJTHH:MM:SSZ"\
> ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>.pub


3 files created in <current directory>
```

## License

This script is licensed under the MIT License.
