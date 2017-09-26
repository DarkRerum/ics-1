# ---------------------------------------------------------------------------
# ��� �������

NAME	= lab1

# ��������� ����������� � �������

CC      = sdcc
CFLAGS  = -I./INCLUDE -c --stack-auto
LFLAGS  = --code-loc 0x2100 --xram-loc 0x6000 --stack-auto --stack-loc 0x80 

# ��������� ������� �������������� ������ ������

PROJECT  = $(shell type PROJECT)
VERSION  = $(shell type VERSION)
BUILD    = $(shell type BUILD)
TYPE     = $(shell type TYPE)

PROJNAME = ${PROJECT}-${VERSION}-${BUILD}-${TYPE}
TARBALL  = ${PROJNAME}.tar

# ��������� M3P

M3P		 = m3p
COMPORT	 = com1
COMLOG	 = $(COMPORT)_log.txt
BAUD	 = 9600	

# �������� � ��������� ��������

SRC_DIR = SRC
# ---------------------------------------------------------------------------

all: lab1

clean:
	del $(NAME).hex
	del $(NAME).bin
	del $(NAME).map
	del $(NAME).mem
	del $(NAME).lnk
	del pm3p_*.txt
	del com?_log.txt
	del $(TARBALL).gz
	del $(SRC_DIR)\*.asm
	del $(SRC_DIR)\*.rel
	del $(SRC_DIR)\*.rst
	del $(SRC_DIR)\*.sym
	del $(SRC_DIR)\*.lst 

load:
	$(M3P) lfile load.m3p


dist:
	tar -cvf $(TARBALL) --exclude=*.tar .
	gzip $(TARBALL)

term:
	$(M3P) echo $(COMLOG) $(BAUD)  openchannel $(COMPORT) +echo 0 term -echo bye


LAB_SRC = \
$(SRC_DIR)/led.c \
$(SRC_DIR)/max.c \
$(SRC_DIR)/lab1.c 

LAB_OBJ = $(LAB_SRC:.c=.rel)

lab1 : $(LAB_OBJ) makefile
	$(CC) $(LAB_OBJ) -o lab1.hex $(LFLAGS)
	$(M3P) hb166 lab1.hex lab1.bin bye


$(LAB_OBJ) : %.rel : %.c makefile
	$(CC) -c $(CFLAGS) $< -o $@  
