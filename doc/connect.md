---
modulename: Transfer
title: /connect/
giturl: gitlab.com/space-sh/transfer
weight: 200
---
# Transfer module: Connect

Connect to a peer via a _TCP_ connection either to send or receive data.


## Example

Sending `hello.txt`:
```sh
cat hello.txt | space -m transfer /connect/ -- "192.168.0.10" "8384"
```

Receiving `cat.png`:
```sh
space -m transfer /connect/ -- "192.168.0.10" "8384" > cat.png
```


Exit status code is expected to be 0 on success.
