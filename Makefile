SRCS:=\
  ./imaged/image.d \
  ./imaged/jpeg.d \
  ./imaged/png.d \
  ./imaged/bmp.d \

OBJS:=$(SRCS:%.d=%.o)

all: test.exe

%.o: %.d
	gdc -funittest -J. -c -o $@ $^

test.exe: $(OBJS) test/generate.o
	gdc -funittest -o $@ $^ -lz
