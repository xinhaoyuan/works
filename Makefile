.PHONY: clean force all

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

all: ${TARGET}

${T_OBJ}/__ts:
	-@mkdir -p ${T_OBJ}
	@touch $@

# Process the project layouts {{{

DESC_FILES  := desc/*
LAYOUT_FILE := ${T_OBJ}/layout.mk

${LAYOUT_FILE}: ${T_OBJ}/__ts ${DESC_FILE}
	@${PRINT} MAKING layout file
	${V}cat ${DESC_FILES} | ${T_BASE}/utl/mklayout.sh $$\{T_OBJ\}/__ts_ $$\{T_OBJ\}/__ts_dep_ > ${LAYOUT_FILE}

-include ${LAYOUT_FILE}

# }}}

# User defined actions

.PHONY: waff-test

waff-test: waff
	${V}cd ../waff/cgi-bin;QUERY_STRING="player=yxh" ./waff.pl 

cwm-test: cwm
	-pkill Xnest
	Xnest :1 -ac &
	sleep 1; DISPLAY=":1" xterm &
	sleep 1; DISPLAY=":1" urxvt &
	sleep 1; DISPLAY=":1" valgrind obj/cwm

endif
