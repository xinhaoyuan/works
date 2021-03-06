.PHONY: clean force default layout

export V        ?= @
export T_BASE   ?= ${PWD}
export T_OBJ    ?= ${T_BASE}/obj
export MAKE     := make -s

PRINT := ${T_BASE}/utl/myecho "${MAKELEVEL}"

-include ${T_BASE}/config.mk

ifeq (${MAKECMDGOALS},clean)

clean: 
	-${V}${RM} -rf ${T_OBJ}

else

default:

${T_OBJ}/__ts:
	-@mkdir -p ${T_OBJ}
	@touch $@

# Process the project layouts 

DESC_FILES  := desc/*
LAYOUT_FILE := ${T_OBJ}/layout.mk

${LAYOUT_FILE}: ${T_OBJ}/__ts ${DESC_FILE}
	@${PRINT} MAKING layout file
	${V}cat ${DESC_FILES} | ${T_BASE}/utl/mklayout.bash $$\{T_OBJ\}/__ts_ $$\{T_OBJ\}/__ts_dep_ > ${LAYOUT_FILE}

layout: ${T_OBJ}/__ts
	@${PRINT} MAKING layout file
	${V}cat ${DESC_FILES} | ${T_BASE}/utl/mklayout.bash $$\{T_OBJ\}/__ts_ $$\{T_OBJ\}/__ts_dep_ > ${LAYOUT_FILE}

-include ${LAYOUT_FILE}

endif
