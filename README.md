# openssl-certchain-scripts
Generate verifiable certificate chain.

## Dependencies

- OpenSSL 1.1.0 installed and commandline-tool openssl added in PATH.

## How to use

Suppose you need a certificate chain **earth -> asia -> china -> fudan**,
where
- **earth** is the root using a 4096-bit RSA key-pair,
- **asia** is the sub-CA using a 2048-bit RSA key-pair,
- **china** is the subsub-CA using a key-pair on curve `prime256v1`,
- **fudan** is the enduser using an key-pair on curve `secp521r1`.

After clone, cd into the repo root dir.

Run `./gen-rsa-root.sh earth 4096`.
This generates `earth-cert.pem`, `earth-key.pem`.

Run `./gen-rsa-subca.sh earth asia 2048`.
This generates the cert file and key file for **asia**.

Run `./gen-ec-subca.sh asia china prime256v1`.

Run `./gen-ec-enduser.sh china fudan secp521r1`.
This generates `fudan-cert.pem`, `fudan-key.pem`, `fudan-chain.pem`.

Write **fudan**'s TLS server program where certificate is loaded as follows.

```
// ...
SSL_CTX *ctx = SSL_CTX_new(TLSv1_2_server_method());
SSL_CTX_use_certificate_chain_file(ctx, "fudan-chain.pem");
SSL_CTX_use_PrivateKey_file(ctx, "key.pem", SSL_FILETYPE_PEM);
// ...
```

Run this TLS server, make it listen on port 4433.

In the same directory, run `openssl s_client -CAfile earth-cert.pem`, which should by default connect to `localhost:4433`.

You should see the handshake success the following message line is printed.

```
Verify return code: 0 (ok)
```

Scroll up and you should see verification log without errors as follows.

```
CONNECTED(00000003)
depth=3 CN = earth
verify return:1
depth=2 CN = asia
verify return:1
depth=1 CN = china
verify return:1
depth=0 CN = fudan
verify return:1
```
