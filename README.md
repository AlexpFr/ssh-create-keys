# SSH Key Pair Generator

This script automates the process of generating a passphrase-protected SSH key pair using the Ed25519 algorithm.  
It simplifies the generation of keys and displays necessary information for saving and using the keys.

## Usage

Recommended filename for the script: `ssh-create-keys.sh`.

Make sure you have the required tools installed:

- `date`
- `openssl`
- `ssh-keygen`
- `sed`
- `awk`
- `cut`
- `xxd`

If necessary, modify the script to change the public key comment variable to `comment="Your comment here"`.  
Run `chmod 755 ssh-create-keys.sh` to make the script executable.  
Execute `./ssh-create-keys.sh` in your terminal to run it.

## Example Output

```
~/ssh-create-keys$ ./ssh-create-keys.sh 
Generating passphrase and public/private ed25519 key pair...

The key fingerprint is:
256 SHA256:vHSytfIIJjAzDYAumDS63j3qlLHkcLR9jSTAnuGVzFc 2024-04-08 (ED25519)

Your private key passphrase is:
3ZjzK67WvcfKMZaFbIuruF1zbgk2h3GGdoYoOn2EV7M

To save your private key with filename ./id_ed25519_2024-04-08_bc74b2b5,
run the following command to create a file in the current directory:

echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jdHIAAAAGYmNyeXB0AAAAGAAAABAIndhjDm
RQLEPoJCLgJjq9AAAAEAAAAAEAAAAzAAAAC3NzaC1lZDI1NTE5AAAAINRKeVibSQvTobCk
pIf/0Ht7gkXvzbxaJy8fahZVBTMjAAAAkGOBQtn/crHYmG2SNC7bAP+8f0tvU05kWCHTr+
MOEJ2SY0NfRIEl1DJUBZqbsI4RBnCJxFipcm3cWufSLSn78NgAISTiCXNybgV6zTY9b4gU
5JBIYRWxM3MWoPYVZuZl8n/19UDeg1+EUgsu8/z8LoPcY7OqKJFZq3MTRu3LrUTFsyiEw8
O1ZSufoUbd8u56qw==
-----END OPENSSH PRIVATE KEY-----"\
> ./id_ed25519_2024-04-08_bc74b2b5


To save your public key with filename ./id_ed25519_2024-04-08_bc74b2b5.pub,
run the following command to create a file in the current directory:

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRKeVibSQvTobCkpIf/0Ht7gkXvzbxaJy8fahZVBTMj 2024-04-08"\
> ./id_ed25519_2024-04-08_bc74b2b5.pub
```

## License

This script is licensed under the MIT License.
