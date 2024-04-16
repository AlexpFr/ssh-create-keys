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
256 SHA256:Qsdua7baY0NEweZxbFA94moKC2z2cz28hZY3KoINfy8 2024-04-14T21:23:25Z (ED25519)

Your private key passphrase is:
tgLar76rti7QLCi6ZD5eWrSWkw3iqIRgcpJG12SeWJn6

The passphrase consists of 44 symbols, with 26 unique symbols. 
It has an entropy of approximately 199 bits, or 4.53 bits per symbol.

To save your private key with filename ./id_ed25519_2024-04-14T21-23-25Z_42c76e6b,
run the following command to create a file in the current directory:

echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jdHIAAAAGYmNyeXB0AAAAGAAAABB7AnenwE
6roDppj57BwuI9AAAAEAAAAAEAAAAzAAAAC3NzaC1lZDI1NTE5AAAAIGRfNGANiAAY8YdV
Ofd+D7oA3POEUjl7JWqyzuNzc1wpAAAAkHvOSTY1nU4fRjY3RXcHir1RZ9RhXbtgdSJxTi
q8VX67qVhNf73hFNU+9U0tJkPMaZp29ImTs2NK+kWtr1AhFFZgJImparPEvu6SW2MwgUk5
9fkVXPkpBIv09nI2iS4Bi+zGC2pOzzP7ruNaT2wyYdbcfq9GjIlxX2BODq+EWhAozRb0sB
Z1eZuZf7AYRDu2IQ==
-----END OPENSSH PRIVATE KEY-----"\
> ./id_ed25519_2024-04-14T21-23-25Z_42c76e6b


To save your public key with filename ./id_ed25519_2024-04-14T21-23-25Z_42c76e6b.pub,
run the following command to create a file in the current directory:

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRfNGANiAAY8YdVOfd+D7oA3POEUjl7JWqyzuNzc1wp 2024-04-14T21-23-25Z"\
> ./id_ed25519_2024-04-14T21-23-25Z_42c76e6b.pub
```

## License

This script is licensed under the MIT License.
