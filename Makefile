.PHONY: all clean cvars
.FORCE:

CXX=g++-10
SDIR=src
ODIR=obj

SRCS=$(wildcard $(SDIR)/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Demo/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Hud/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Routing/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Speedrun/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Speedrun/Rules/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Stats/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/ReplaySystem/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Tas/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Tas/TasTools/*.cpp)
SRCS+=$(wildcard $(SDIR)/Features/Timer/*.cpp)
SRCS+=$(wildcard $(SDIR)/Offsets/*.cpp)
SRCS+=$(wildcard $(SDIR)/Offsets/Linux/*.cpp)
SRCS+=$(wildcard $(SDIR)/Modules/*.cpp)
SRCS+=$(wildcard $(SDIR)/Utils/*.cpp)

OBJS=$(patsubst $(SDIR)/%.cpp, $(ODIR)/%.o, $(SRCS))

# VERSION=$(shell git describe --tags)
VERSION=1.0

# Header dependency target files; generated by g++ with -MMD
DEPS=$(OBJS:%.o=%.d)

WARNINGS=-Wall -Wno-unused-function -Wno-unused-variable -Wno-parentheses -Wno-unknown-pragmas -Wno-register -Wno-sign-compare
CXXFLAGS=-std=c++17 -m32 $(WARNINGS) -I$(SDIR) -fPIC -D_GNU_SOURCE -DSFML_STATIC -DCURL_STATICLIB
LDFLAGS=-m32 -shared -lstdc++fs

# Import config.mk, which can be used for optional config
-include config.mk

all: krzymod.so
clean:
	rm -rf $(ODIR) krzymod.so src/Version.hpp

-include $(DEPS)

krzymod.so: src/Version.hpp $(OBJS)
	$(CXX) $^ $(LDFLAGS) -o $@

$(ODIR)/%.o: $(SDIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -MMD -c $< -o $@

src/Version.hpp: .FORCE
	echo "#define PLUGIN_VERSION \"$(VERSION)\"" >"$@"
	if [ -z "$$RELEASE_BUILD" ]; then echo "#define PLUGIN_DEV_BUILD 1" >>"$@"; fi


