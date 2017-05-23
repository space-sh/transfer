---
modulename: Transfer
title: /connect/
giturl: gitlab.com/space-sh/transfer
editurl: /edit/master/doc/connect.md
weight: 200
---
# Transfer module: Connect

Connect to a peer via a _TCP_ connection either to send or receive data.


## Example

Sending `hello.txt`:
```sh
$ cat hello.txt | space -m transfer /connect/ -- "192.168.0.10" "9333"
```

Receiving `cat.png`:
```sh
$ space -m transfer /connect/ -- "192.168.0.10" "9333" > cat.png
```

### Connect securely

Sending `hello.txt`:
```sh
$ cat hello.txt | space -m transfer /connect/ -- "192.168.0.10" "9333" "1"
```

Or using environment variables:  

Sending `hello.txt`:
```sh
$ cat hello.txt | space -m transfer /connect/ -e host=192.168.0.10 -e port=9333 -e secure=1
```

Skip server certificate verification:  
```sh
$ cat hello.txt | space -m transfer /connect/ -e host=192.168.0.10 -e port=9333 -e secure=1 -e verify=0
```


Exit status code is expected to be 0 on success.
