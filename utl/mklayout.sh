#!/bin/bash

PREFIX=$1
DEPPREFIX=$2
SED=$(which sed)

declare -A DEPS
declare -A PATHS

while read line; do
    if [[ ! "$line" =~ ^# ]] && [[ "$line" =~ [^:\"]+:[^:\"]+:.* ]]; then
        eval $(echo $line | ${SED} -n -e "s/\([^:\"][^:\"]*\):\([^:\"][^:\"]*\):\(.*\)/NAME=\"\1\";PATH=\"\2\";DEP=\"\3\"/p")
        PATH=${PATH%/}
        if [ -d "$PATH" -a -r "${PATH}/Makefile" ] ; then
            PATHS[$NAME]="$PATH"
            DEPS[$NAME]="$DEP"
        fi
    fi
done

PRJS="${!PATHS[@]}"

echo ".PHONY: force"
for PRJ in ${PRJS}; do
    echo "OBJ_${PRJ}  := ${PREFIX}${PRJ}"
    echo "DEP_${PRJ}  := ${DEPPREFIX}${PRJ}"
    REALPATH=$( cd ${PATHS[${PRJ}]}; pwd )
    echo "export PATH_${PRJ} := ${REALPATH}"
    echo ".PHONY: ${PRJ}"
    echo "${PRJ}: \${OBJ_${PRJ}}"
done

for PRJ in ${PRJS}; do
    echo -n "\${DEP_${PRJ}}:"
    for DEP in ${DEPS[$PRJ]}; do
        echo -n " \${OBJ_${DEP}}"
    done
    echo 
    echo $'\t'"@touch \$@"
    echo "\${OBJ_${PRJ}}: \${DEP_${PRJ}} force"
    echo $'\t'"@PRJ=${PRJ} \${MAKE} -q -C \${PATH_${PRJ}} all || touch \${DEP_${PRJ}}"
    echo $'\t'"@test '(' -e \$@ ')' -a '(' '!' '(' \${DEP_${PRJ}} -nt \$@ ')' ')' || \\"
    echo $'\t'"( \${PRINT} \"MAKING ${PRJ}:\"; PRJ=${PRJ} \${MAKE} -C \${PATH_${PRJ}} all && touch \$@ )"
done
