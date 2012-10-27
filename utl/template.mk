FN_ENCODE ?= $(shell echo $(1) | sed -e 's!_!_1!g' -e 's!/!_2!g')
FN_DECODE ?= $(shell echo $(1) | sed -e 's!_2!/!g' -e 's!_1!_!g')

OBJFILES := $(addprefix ${T_OBJ}/${PRJ}-,$(addsuffix .o,$(foreach FILE,${SRCFILES},$(call FN_ENCODE,${FILE}))))
DEPFILES := $(OBJFILES:.o=.d)

PRINT := @${T_BASE}/utl/myecho ${MAKELEVEL}

-include ${DEPFILES}

T_CC_ALL_FLAGS  ?= ${T_CC_BASE_FLAGS} ${T_CC_OPT_FLAGS} ${T_CC_DEBUG_FLAGS} ${T_CC_FLAGS} ${T_C_ONLY_FLAGS}
T_CXX_ALL_FLAGS ?= ${T_CC_BASE_FLAGS} ${T_CC_OPT_FLAGS} ${T_CC_DEBUG_FLAGS} ${T_CC_FLAGS} ${T_CXX_ONLY_FLAGS}

# ASM

${T_OBJ}/${PRJ}-%.S.d: 
	${V}${CC} -D__ASSEMBLY__ -MM ${T_CC_ALL_FLAGS} -MT $(@:.d=.o) $(call FN_DECODE,$*).S -o$@
	${V}echo "$(@:.d=.o): $(call FN_DECODE,$*).S" >> $@

${T_OBJ}/${PRJ}-%.S.o: ${T_OBJ}/${PRJ}-%.S.d
	${PRINT} CC $(call FN_DECODE,$*).S
	${V}${CC} -D__ASSEMBLY__ ${T_CC_ALL_FLAGS} -c $(call FN_DECODE,$*).S -o $@

# C

${T_OBJ}/${PRJ}-%.c.d: 
	${V}${CC} -MM ${T_CC_ALL_FLAGS} -MT $(@:.d=.o) $(call FN_DECODE,$*).c -o$@
	${V}echo "$(@:.d=.o): $(call FN_DECODE,$*).c" >> $@

${T_OBJ}/${PRJ}-%.c.o: ${T_OBJ}/${PRJ}-%.c.d
	${PRINT} CC $(call FN_DECODE,$*).c
	${V}${CC} ${T_CC_ALL_FLAGS} -c $(call FN_DECODE,$*).c -o $@

# CXX

${T_OBJ}/${PRJ}-%.cpp.d: 
	${V}${CXX} -MM ${T_CXX_ALL_FLAGS} -MT $(@:.d=.o) $(call FN_DECODE,$*).cpp -o$@
	${V}echo "$(@:.d=.o): $(call FN_DECODE,$*).cpp" >> $@

${T_OBJ}/${PRJ}-%.cpp.o: ${T_OBJ}/${PRJ}-%.cpp.d
	${PRINT} CXX $(call FN_DECODE,$*).cpp
	${V}${CXX} ${T_CXX_ALL_FLAGS} -c $(call FN_DECODE,$*).cpp -o $@
