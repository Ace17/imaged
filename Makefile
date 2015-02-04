BIN?=bin

SRCS:=\
  imaged/image.d \
  imaged/jpeg.d \
  imaged/png.d \
  imaged/bmp.d \

OBJS:=$(SRCS:%.d=$(BIN)/%.o)

all: $(BIN)/test.exe

test: $(BIN)/test.exe
	$(BIN)/test.exe

$(BIN)/%.o: %.d
	@mkdir -p $(dir $@)
	gdc -funittest -J. -c -o $@ $^

$(BIN)/test.exe: $(OBJS) $(BIN)/test/generate.o
	@mkdir -p $(dir $@)
	gdc -funittest -o $@ $^

clean:
	rm -rf $(BIN)

