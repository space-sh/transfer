---
modulename: Transfer
title: /listen/
giturl: gitlab.com/space-sh/transfer
weight: 200
---
# Transfer module: Listen

Listen on particular port for a connecting peer.


## Example

Listening on port `8384`, ready for sending `hello.txt`:
```sh
cat hello.txt | space -m transfer /listen/ -- "8384"
```

Listening on port `8384`, ready for receiving `cat.png`:
```sh
space -m transfer /listen/ -- "8384" > cat.png
```

Exit status code is expected to be 0 on success.
