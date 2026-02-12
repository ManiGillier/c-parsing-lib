
MAJOR	:=	0
MINOR	:=	0.0

NAME	:=	parsing
CPPFLAGS	+= -I include

CFLAGS	+= -Wall -Wextra -Werror -fPIC

CC	?=	gcc
AR	?=	ar
LN	?=	ln -f
CP	?=	cp -f

SRC	+= src/main.c

HEADERS +=

OBJ	:=	$(SRC:%.c=%.o)

SO_NAME_A	:=	$(NAME).so
SO_NAME_M	:=	$(SO_NAME_A).$(MAJOR)
SO_NAME_MM	:=	$(SO_NAME_M).$(MINOR)

all: $(SO_NAME_MM) $(SO_NAME_M) $(SO_NAME_A)
.PHONY: all

$(SO_NAME_MM): $(OBJ) $(HEADERS)
	$(CC) -shared -o $@ $^

$(SO_NAME_M): $(SO_NAME_MM)
	$(LN) -s $< $@

$(SO_NAME_A): $(SO_NAME_M)
	$(LN) -s $< $@

clean:
	$(RM) $(OBJ)
.PHONY: clean

fclean:
	$(RM) $(SO_NAME_MM)
	$(RM) $(SO_NAME_M)
	$(RM) $(SO_NAME_A)
.PHONY: fclean

re: clean fclean
	$(MAKE) all
.PHONY: re

install-local: $(SO_NAME_MM)
	$(CP) $^ ~/.local/lib
	$(LN) -s ~/.local/lib/$(SO_NAME_MM) ~/.local/lib/$(SO_NAME_M)
	$(LN) -s ~/.local/lib/$(SO_NAME_M) ~/.local/lib/$(SO_NAME_A)
.PHONY: install-local

install-global: $(SO_NAME_MM) $(SO_NAME_M) $(SO_NAME_A)
	$(CP) $^ /usr/lib64
	$(LN) -s /usr/lib64/$(SO_NAME_MM) /usr/lib64/$(SO_NAME_M)
	$(LN) -s /usr/lib64/$(SO_NAME_M) /usr/lib64/$(SO_NAME_A)
.PHONY: install-global

install: install-local
.PHONY: install

test: $(SO_NAME_MM)
.PHONY: test
