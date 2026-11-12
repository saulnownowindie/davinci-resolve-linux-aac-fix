include .mk.defs

BASEDIR = ./

BUILD_DIR = .
SUBDIRS = wrapper

ifeq ($(OS_TYPE), Linux)
LDFLAGS = -shared '-Wl,-rpath,$$ORIGIN' -Wl,-z,origin -lpthread  -lavcodec -lavutil
else
LDFLAGS = -dynamiclib
endif

TARGET = $(BINDIR)/aac_encoder_plugin.dvcp

OBJDIR = $(BUILD_DIR)/build
BINDIR = $(BUILD_DIR)/bin

.PHONY: all

HEADERS = plugin.h audio_encoder.h
SRCS = plugin.cpp audio_encoder.cpp wrapper/host_api.cpp
OBJS = $(SRCS:%.cpp=$(OBJDIR)/%.o)

# Portabilidad: el repo original fijaba rutas de GCC 14 de Red Hat
# (/usr/include/c++/14, /usr/include/c++/x86_64-redhat-linux/14) que no
# existen en Ubuntu/Debian u otras distros. clang++ resuelve libstdc++
# por si mismo; solo forzamos -stdlib cuando el compilador es clang.
CFLAGS += -I$(BASEDIR)/wrapper
ifeq ($(OS_TYPE), Linux)
  ifneq (,$(findstring clang,$(CC)))
    CFLAGS += -stdlib=libstdc++
  endif
endif

all: prereq make-subdirs $(HEADERS) $(SRCS) $(OBJS) $(TARGET)

prereq:
	mkdir -p $(OBJDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(OBJDIR)/wrapper  # Ensure wrapper directory exists

$(OBJDIR)/%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJDIR)/wrapper/%.o: wrapper/%.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET):
	$(CC) $(OBJDIR)/*.o $(LDFLAGS) -o $(TARGET)
#	install -Dm755 $(TARGET) /opt/resolve/IOPlugins/aac_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/aac_encoder_plugin.dvcp

clean: clean-subdirs
	rm -rf $(OBJDIR)
	rm -rf $(BINDIR)

make-subdirs:
	@for subdir in $(SUBDIRS); do \
	echo "Making $$subdir"; \
	(cd $$subdir; make; cd ..) \
	done

clean-subdirs:
	@for subdir in $(SUBDIRS); do \
	echo "Making clean in $$subdir"; \
	(cd $$subdir; make clean; cd ..) \
	done

