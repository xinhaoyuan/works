.PHONY: layout clean force all

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

${T_OBJ}:
	@mkdir -p ${T_OBJ}

# Process the prj dependency {{{

LAYOUT_FILE := ${T_OBJ}/layout.mk

layout: ${T_OBJ}
	${V}${T_BASE}/utl/mklayout ${T_BASE}/prj $$\{T_BASE\}/prj $$\{T_OBJ\}/__ts_ $$\{T_OBJ\}/__ts_dep_ > ${LAYOUT_FILE}

${LAYOUT_FILE}: ${T_OBJ}
	${V}${T_BASE}/utl/mklayout ${T_BASE}/prj $$\{T_BASE\}/prj $$\{T_OBJ\}/__ts_ $$\{T_OBJ\}/__ts_dep_ > $@

-include ${LAYOUT_FILE}

${T_OBJ}/__ts_dep_%:
	@touch $@

${T_OBJ}/__ts_%: force
	@PRJ=$* ${MAKE} -q -C prj/$* all || touch ${T_OBJ}/__ts_dep_$*
	@test "(" -e $@ ")" -a "(" "!" "(" ${T_OBJ}/__ts_dep_$* -nt $@ ")" ")" || \
		( ${PRINT} "MAKING $*:"; PRJ=$* ${MAKE} -C prj/$* all && touch $@ )

# }}}

# User defined actions

.PHONY: stat test-waff

stat: all
	${V}./loc.sh

waff-test: waff
	${V}cd ../waff/cgi-bin;QUERY_STRING="player=yxh" ./waff.pl 

cwm-test: cwm
	-pkill Xnest
	Xnest :1 -ac &
	sleep 1; DISPLAY=":1" xev &
	sleep 1; DISPLAY=":1" urxvt &
	sleep 1; DISPLAY=":1" obj/cwm

endif
