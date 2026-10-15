#/usr/bin/env bash

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! [ -e ${HERE}/sun_status ]; then echo "geo" > ${HERE}/sun_status; fi

status=$(cat ${HERE}/sun_status)

if [ -z $1 ]; then

    echo "{ \"alt\": \"${status}\", \"class\": \"custom-sunsetr\" }"
else
    case ${status} in
        geo)
            status=static
            ;;
        static)
            status=geo
            ;;
        *) ;;
    esac
    echo ${status} > ${HERE}/sun_status
    sunsetr set transition_mode=${status}
fi


