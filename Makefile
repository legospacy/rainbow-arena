SOURCES = $(wildcard **.moon)
LUA_FILES = ${SOURCES:.moon=.lua}

run: $(LUA_FILES)
	love .

%.lua: %.moon
	moonc $<
