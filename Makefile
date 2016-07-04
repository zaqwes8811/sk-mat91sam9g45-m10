# fixme: add gdb
# fixme: add runsv

# workspace
WS=..
MKIMAGE=$(WS)/u-boot-2010.09/tools/mkimage
TFTPBOOT=../tftpboot
#/tftpboot

# Этот билдрут не копирует тулчейн в output
#PREFIX=$(WS)/buildroot-2010.08/output/bin/arm-none-linux-gnueabi-
PREFIX=/opt/cross-gcc/arm-2007q1/bin/arm-none-linux-gnueabi-

all: buildroot uboot kernel
	# Pack kernel
	cd $(WS)/linux-2.6.36-rc6 && \
	$(PREFIX)objcopy -O binary -R .note -R .comment -S vmlinux linux.bin && \
	gzip -c -9 linux.bin > linux.bin.gz && \
	$(MKIMAGE) -A arm -O linux -T kernel -C gzip -a 0x70008000 -e 0x70008000 -n "Linux Kernel Image" -d linux.bin.gz zlinux && \
	cp ./zlinux $(TFTPBOOT)/zlinux && \
	$(MKIMAGE) -A arm -O linux -T kernel -a 0x70008000 -e 0x70008000 -n "Linux Kernel Image" -d linux.bin image_sd.bin && \
	cp ./image_sd.bin $(TFTPBOOT)/mat91_sd.bin


# Subprojects

buildroot_menuconfig:
	cd $(WS)/buildroot-2010.08 ; make menuconfig

buildroot:
	#cp -r ./my_files/rootfs/* ./output/target
	
	cd $(WS)/buildroot-2010.08 && make

$(TFTPBOOT):
	mkdir -p $(TFTPBOOT)

busybox:
	# Это в стандартном расположении
	cd $(WS)/buildroot-2010.08 ; make busybox-menuconfig

# Kernel
# $(WS)/u-boot-2010.09/tools/mkimage
kernel: $(TFTPBOOT)
	cd $(WS)/linux-2.6.36-rc6 && \
		make -j3 ARCH=arm CROSS_COMPILE=$(PREFIX)

# fixme: не знаю как сделать зависимость, через файл нужно как-то
#$(WS)/u-boot-2010.09/tools/mkimage: 

uboot:
	cd $(WS)/u-boot-2010.09 && \
		make ARCH=arm CROSS_COMPILE=$(PREFIX) at91sam9m10g45ek_nandflash_config && \
		make ARCH=arm CROSS_COMPILE=$(PREFIX) && \
		cp ./u-boot.bin $(TFTPBOOT)/uboot

# Clean
clean_all:
	rm -rf $(WS)/buildroot-2010.08/dl \
		$(WS)/buildroot-2010.08/output

clean_kernel:
	cd $(WS)/linux-2.6.36-rc6 && make clean ARCH=arm CROSS_COMPILE=$(PREFIX)

clean_uboot:
	cd $(WS)/u-boot-2010.09 && \
		make ARCH=arm distclean CROSS_COMPILE=$(PREFIX)


	
