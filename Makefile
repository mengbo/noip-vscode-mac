CC = clang
CXX = clang++
CFLAGS = -g -Wall
CXXFLAGS = -g -Wall -std=c++11

C_SRCS = $(wildcard *.c) $(wildcard */*.c)
CXX_SRCS = $(wildcard *.cpp) $(wildcard */*.cpp)
C_PROGS = $(patsubst %.c, %, $(C_SRCS))
CXX_PROGS = $(patsubst %.cpp, %, $(CXX_SRCS))
SRCS = $(C_SRCS) $(CXX_SRCS)
PROGS = $(C_PROGS) $(CXX_PROGS)

all: $(PROGS)

clean:
	rm -rf $(PROGS) *.dSYM */*.dSYM