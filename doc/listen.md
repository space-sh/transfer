---
modulename: Transfer
title: /listen/
giturl: gitlab.com/space-sh/transfer
editurl: /edit/master/doc/listen.md
weight: 200
---
# Transfer module: Listen

Listen on particular port for a connecting peer.


## Example

Listening on port `9333`, ready for sending `hello.txt`:
```sh
cat hello.txt | space -m transfer /listen/ -- "0.0.0.0" "9333"
```

Listening on port `9333`, ready for receiving `cat.png`:
```sh
space -m transfer /listen/ -- "0.0.0.0" "9333" > cat.png
```

Or using environment variables:  

Listening on port `9333`, ready for receiving `cat.png`:
```sh
space -m transfer /listen/ -e port=9333 > cat.png
```


### Using secure connection

Listening on port `9333` using SSL cert, ready for receiving `cat.png`:
```sh
space -m transfer /listen/ -e port=9333 -e cert=mycert.pem > cat.png
```

If using a self signed certificate, the client must use `-e verify=0` to disable certificate verification.

How to create a self signed certificate using the SSL module:  

```sh
space -m ssl /genselfsigned/ -e certname=mycert
```

### Firewall workarounds

When wanting to send a file between two personal computers firewalls may be restricting
incoming traffic. Either you open a port in the firewall to let the client connect to
the listener behind the firewall, or you can setup the connection to go via a third party
server, which is not behind a strict firewall.  

If you are do not want an encrypted connection it would be as simple as wrapping the transfer
module in the ssh module:  

```sh
space -m ssh /wrap/ -e SSHHOST=IP -m transfer /listen/ -e port=9333 > cat.png
```

This makes a secure SSH connection from your computer to the server which will
be running `socat` to listen on connections, which will then be redirected through
the SSH connection back to you.

Have the client connect to IP:9333 instead of your own IP address.

This connection will however be unsecure between the client and the remote server, since it does not use a server certificate.
To solve this and use a secure connection from end to end there are two options. First option is to upload your certificate to the
server and run -m transfer using -e cert=. This is not optimal since you need to upload the certificate
to the third party server prior. The second option involves making an SSH tunnel from the third party
server back home where we have the transfer module listen to a local port which is tunnelled to the
server port, in which case we can use the certificate locally, this is the recommended option.  

To setup a SSH tunnel:  
```sh
space -m ssh /tunnel/reverse/ -e SSHTUNNEL=0.0.0.0:9333:127.0.0.1:9333 -e SSHHOST=address
```
This will open a SSH connection to the remote server and make a reverse tunnel back to the local computer.

Then in another terminal:  
```sh
space -m transfer /listen/ -e port=9333 -e cert=mycert.pem
```

The client will connect to the remote server using a secure connection:  
```sh
space -m transfer -e host=IP -e port=9333 -e secure=1
```

Exit status code is expected to be 0 on success.
