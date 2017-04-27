# Transfer module | [![build status](https://gitlab.com/space-sh/transfer/badges/master/build.svg)](https://gitlab.com/space-sh/transfer/commits/master)

Provides a way to pipe data in and out via a TCP connection,
raw or encrypted.



## /connect/
	Connect to peer

	Establish a TCP connection to remote part to transfer or receive data.
	Use pipe or redirection to send/receive file upon
	successful connection.
	


## /listen/
	Listen for peer

	Listen on port and wait for a connecting peer.
	Use pipe or redirection to send/receive file upon successful connection.
	Provide the cert variable for a secure connection using socat and openssl.
	Set verify=1 to require client certificate.
	


# Functions 

## TRANSFER\_DEP\_INSTALL()  
  
  
  
Check for dependencies  
  
  
  
## TRANSFER\_CONNECT()  
  
  
  
Connect to a peer  
  
### Parameters:  
- $1: host IP  
- $2: port number  
- $3: secure, use secure connection without client cert, optional.  
- $4: verify, verify server cert on secure connection, optional  
- $5: cert, for secure connection, optional  
  
### Returns:  
- Non-zero on error.  
  
  
  
## TRANSFER\_LISTEN()  
  
  
  
Listen for peer connection.  
  
### Parameters:  
- $1: host  
- $2: port number  
- $3: cert, for secure connection, optional  
- $4: verify, verify client cert on secure connection, optional  
  
### Returns:  
- Non-zero on error.  
  
  
  
