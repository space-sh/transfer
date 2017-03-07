# Transfer module | [![build status](https://gitlab.com/space-sh/transfer/badges/master/build.svg)](https://gitlab.com/space-sh/transfer/commits/master)

Provides a way to pipe data in and out via a TCP connection.



## /connect/
	Connect to peer

	Establish a TCP connection to remote part to transfer or receive data.
	Use pipe or redirection to send/receive file upon
	successful connection.
	


## /listen/
	Listen for peer

	Listen on port for a connecting peer.
	Use pipe or redirection to send/receive file upon
	successful connection.
	


# Functions 

## TRANSFER\_DEP\_INSTALL ()  
  
  
  
Check for dependencies  
  
  
  
## TRANSFER\_CONNECT ()  
  
  
  
Connect to a peer  
  
### Parameters:  
- $1: host IP  
- $2: port number  
  
### Returns:  
- Non-zero on error.  
  
  
  
## TRANSFER\_LISTEN ()  
  
  
  
Listen for peer connection.  
  
### Parameters:  
- $1: port number  
  
### Returns:  
- Non-zero on error.  
  
  
  
