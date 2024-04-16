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

If necessary, modify the script to change the public key comment variable to `comment="Your comment here"`.  
Run `chmod 755 ssh-create-keys.sh` to make the script executable.  
Execute `./ssh-create-keys.sh` in your terminal to run it.

## Example Output

```
~/ssh-create-keys$ ./ssh-create-keys.sh 
Generating passphrase and public/private ed25519 key pair...

The key fingerprint is:
256 SHA256:<fingerprint> AAAA-MM-JJTHH:MM:SSZ (ED25519)

Your private key passphrase is:
<passphrase>

The passphrase consists of xx symbols, with xx unique symbols. 
It has an entropy of approximately xxx bits, or x.xx bits per symbol.

To save your private key with filename ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>,
run the following command to create a file in the current directory:

echo "-----BEGIN OPENSSH PRIVATE KEY-----
<armored private key data>
-----END OPENSSH PRIVATE KEY-----"\
> ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>


To save your public key with filename ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>.pub,
run the following command to create a file in the current directory:

echo "ssh-ed25519 <armored public key data> AAAA-MM-JJTHH:MM:SSZ"\
> ./id_ed25519_AAAA-MM-JJTHH-MM-SSZ_<short fingerprint>.pub
```

## License

This script is licensed under the MIT License.
