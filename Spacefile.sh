TRANSFER_DEP_INSTALL ()
{
    return
}

TRANSFER_CONNECT ()
{
    SPACE_SIGNATURE="host port"
    SPACE_CMDDEP="PRINT"

    local host="${1}"
    shift

    local port="${1}"
    shift

    local GNU=""
    # netcat comes in many different flavours, if we are using the GNU
    # version we want the -c switch the close connection on EOF.
    local version
    version="$(nc --help 2>&1)"
    version="${version%%\ *}"
    if [ "${version}" = "GNU" ]; then
        GNU=""
        PRINT "netcat is GNU version." "debug"
    else
        PRINT "netcat is non GNU version." "debug"
    fi

    PRINT "Connecting to ${host}:${port}."

    nc ${GNU} ${host} ${port}
}

TRANSFER_LISTEN ()
{
    SPACE_SIGNATURE="port"
    SPACE_CMDDEP="PRINT"

    local host=""

    local port="${1}"
    shift

    local GNU=""
    # netcat comes in many different flavours, if we are using the GNU
    # version we want the -c switch the close connection on EOF.
    local version
    version="$(nc --help 2>&1)"
    version="${version%%\ *}"
    if [ "${version}" = "GNU" ]; then
        GNU=""
        PRINT "netcat is GNU version." "debug"
    else
        PRINT "netcat is non GNU version." "debug"
    fi

    if [ -t 1 ]; then
        PRINT "STDOUT is a terminal, if you are expecting a file transfer you might want to redirect stdout to a file." "warning"
    fi

    PRINT "Listening to ${host}:${port}."

    nc ${GNU} -l ${host} -p ${port}
}
