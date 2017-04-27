#
# Copyright 2016-2017 Blockie AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Disable warning about indirectly checking status code
# shellcheck disable=SC2181

#================================
# TRANSFER_DEP_INSTALL
#
# Check for dependencies
#
#================================
TRANSFER_DEP_INSTALL()
{
    SPACE_DEP="PRINT OS_IS_INSTALLED"       # shellcheck disable=SC2034
    SPACE_ENV="SUDO=${SUDO-}"              # shellcheck disable=SC2034

    OS_IS_INSTALLED "socat" "socat"

    if [ "$?" -eq 0 ]; then
        PRINT "socat found." "ok"
    else
        PRINT "Failed finding socat." "error"
        return 1
    fi

    OS_IS_INSTALLED "openssl"

    if [ "$?" -ne 0 ]; then
        PRINT "openssl found." "ok"
    else
        PRINT "Failed finding openssl, secure connection will not work." "error"
    fi
}


# Disable warning about indirectly checking status code
# shellcheck disable=SC2181

#================================
# TRANSFER_CONNECT
#
# Connect to a peer
#
# Parameters:
#   $1: host IP
#   $2: port number
#   $3: secure, use secure connection without client cert, optional.
#   $4: verify, verify server cert on secure connection, optional
#   $5: cert, for secure connection, optional
#
# Returns:
#   Non-zero on error.
#
#================================
TRANSFER_CONNECT()
{
    # shellcheck disable=SC2034
    SPACE_SIGNATURE="host:1 port:1 [secure verify cert]"
    SPACE_DEP="PRINT OS_IS_INSTALLED"       # shellcheck disable=SC2034
    SPACE_ENV="SUDO=${SUDO-}"               # shellcheck disable=SC2034

    local host="${1}"
    shift

    local port="${1}"
    shift

    local secure="${1:-0}"
    shift $(( $# > 0 ? 1 : 0 ))

    local verify="${1:-1}"
    shift $(( $# > 0 ? 1 : 0 ))

    local cert="${1-}"
    shift $(( $# > 0 ? 1 : 0 ))

    local SUDO="${SUDO-}"
    # Preferably we use socat.
    OS_IS_INSTALLED "socat"
    if [ "$?" -eq 0 ]; then
        if [ -n "${cert}" ] || [ "${secure}" = "1" ]; then
            PRINT "Connecting to ${host}:${port} securely using cert:${cert}, verify:${verify}."
            ${SUDO} socat - "openssl-connect:${host}:${port},verify=${verify}${cert:+,cert=$cert}"
        else
            PRINT "Connecting to ${host}:${port}."
            ${SUDO} socat - "TCP:${host}:${port}"
        fi
    else
        PRINT "socat is not available, falling back to netcat which is somewhat tricky, and you might have to ctrl-c it to quit it when piping." "warning"
        if [ -n "${cert}" ]; then
            PRINT "A cert has been provided for secure connection but socat is not available." "error"
            return 1
        fi
        PRINT "Connecting to ${host}:${port}."
        ${SUDO} nc "${host}" "${port}"
    fi
}


# Disable warning about indirectly checking status code
# shellcheck disable=SC2181

#================================
# TRANSFER_LISTEN
#
# Listen for peer connection.
#
# Parameters:
#   $1: host
#   $2: port number
#   $3: cert, for secure connection, optional
#   $4: verify, verify client cert on secure connection, optional
#
# Returns:
#   Non-zero on error.
#
#================================
TRANSFER_LISTEN()
{
    # shellcheck disable=SC2034
    SPACE_SIGNATURE="host port:1 [cert verify]"
    SPACE_DEP="PRINT OS_IS_INSTALLED"       # shellcheck disable=SC2034
    SPACE_ENV="SUDO=${SUDO-}"               # shellcheck disable=SC2034

    local host="${1:-0.0.0.0}"
    shift

    local port="${1}"
    shift

    local cert="${1-}"
    shift $(( $# > 0 ? 1 : 0 ))

    local verify="${1:-0}"
    shift $(( $# > 0 ? 1 : 0 ))

    local SUDO="${SUDO-}"
    if [ -t 1 ]; then
        PRINT "STDOUT is a terminal, if you are expecting a file transfer you might want to redirect stdout to a file." "warning"
    fi

    # Preferably we use socat.
    OS_IS_INSTALLED "socat"
    if [ "$?" -eq 0 ]; then
        if [ -n "${cert}" ]; then
            PRINT "Listening securely on ${host}:${port} using cert: ${cert} with cert, verify:${verify}."
            ${SUDO} socat "openssl-listen:${port},bind=${host},reuseaddr,cert=${cert},verify=${verify}" -
        else
            PRINT "Listening on ${host}:${port}."
            ${SUDO} socat "TCP-LISTEN:${port},bind=${host},reuseaddr" -
        fi
    else
        PRINT "socat is not available, falling back to netcat which is somewhat tricky, and you might have to ctrl-c it to quit it when piping." "warning"
        if [ -n "${cert}" ]; then
            PRINT "A cert has been provided for secure connection but socat is not available." "error"
            return 1
        fi
        PRINT "Listening on ${host}:${port}."
        ${SUDO} nc -l "${host}" -p "${port}"
    fi
}
