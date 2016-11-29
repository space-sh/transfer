#
# Copyright 2016 Blockie AB
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
