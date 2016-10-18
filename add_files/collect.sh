#!/bin/bash

target=${1}
archive=${2}

public_base=/opt/collected

if [ ! "${target}" ]
then
    echo 'Please set target directory.' 1>&2
    exit 1
fi

if [ ! "${archive}" ]
then
    archive="$(basename ${target}).tar.gz"
fi

parse_ldd(){
    cat - | sed -ne "/=>/{\@${target}@!s/.*=> \| .*//g p}" | sort | uniq | \
        while read -r lib
        do
            [ -f "${lib}" ] && echo "${lib}"
        done
}

set -eu

needs=""
for file in $(find ${target} -type f)
do
    set +e
    libs=$(ldd -v ${file} 2>/dev/null); res=$?
    set -e
    if [ $res -eq 0 ]
    then
        needs=$(echo -e "${needs}\n$(echo "${libs}" | parse_ldd)")
    else
        shebang=$(head -n1 ${file})
        if $(echo "${shebang}" | grep -E '^#!' > /dev/null)
        then
            interpreter=""
            if [[ ${shebang} =~ '/env ' ]]
            then
                cmd=$(echo "${shebang}" | sed -ne 's/[^ ]\+\s//p')
                interpreter=$(type -p ${cmd%% *})
            else
                interpreter=${shebang#\#\!}
                interpreter=${interpreter%% *}
            fi
            needs=$(echo -e "${needs}\n${interpreter}\n$(ldd -v ${interpreter} | parse_ldd)")
        fi
    fi
done

mkdir -p ${public_base}
tar -zchf ${public_base}/${archive} ${target} $([ "${needs}" ] && echo "${needs}" | sort | uniq)
