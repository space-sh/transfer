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

clone os

TRANSFER_DEP_INSTALL ()
{
    SPACE_CMDDEP="PRINT OS_IS_INSTALLED"
    SPACE_CMDENV="SUDO=\${SUDO-}"

    OS_IS_INSTALLED "socat" "socat"

    if [ "$?" -eq 0 ]; then
        PRINT "Dependencies found." "success"
    else
        PRINT "Failed finding dependencies." "error"
        return 1
    fi
}

TRANSFER_CONNECT ()
{
    SPACE_SIGNATURE="host port"
    SPACE_CMDDEP="PRINT OS_IS_INSTALLED"

    local host="${1}"
    shift

    local port="${1}"
    shift

    # Preferably we use socat.
    OS_IS_INSTALLED "socat"
    if [ "$?" -eq 0 ]; then
        PRINT "Connecting to ${host}:${port}."
        socat - TCP:${host}:${port}
    else
        PRINT "socat is not available, falling back to netcat which is somewhat tricky, and you might have to ctrl-c it to quit it when piping." "warning"
        PRINT "Connecting to ${host}:${port}."
        nc ${host} ${port}
    fi
}

TRANSFER_LISTEN ()
{
    SPACE_SIGNATURE="port"
    SPACE_CMDDEP="PRINT OS_IS_INSTALLED"

    local host="0.0.0.0"

    local port="${1}"
    shift

    if [ -t 1 ]; then
        PRINT "STDOUT is a terminal, if you are expecting a file transfer you might want to redirect stdout to a file." "warning"
    fi

    # Preferably we use socat.
    OS_IS_INSTALLED "socat"
    if [ "$?" -eq 0 ]; then
        PRINT "Listening to ${host}:${port}."
        socat TCP-LISTEN:${port},bind=${host},reuseaddr -
    else
        PRINT "socat is not available, falling back to netcat which is somewhat tricky, and you might have to ctrl-c it to quit it when piping." "warning"
        PRINT "Listening to ${host}:${port}."
        nc -l ${host} -p ${port}
    fi
}
