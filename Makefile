# workspace
WS=..

# Этот билдрут не копирует тулчейн в output
#PREFIX=$(WS)/buildroot-2010.08/output/bin/arm-none-linux-gnueabi-
PREFIX=/opt/cross-gcc/arm-2007q1/bin/arm-none-linux-gnueabi-

buildroot_menuconfig:
	cd $(WS)/buildroot-2010.08 ; make menuconfig

buildroot:
	cd $(WS)/buildroot-2010.08 && make

# Kernel
kernel:
	cd $(WS)/linux-2.6.36-rc6 && \
		make -j3 ARCH=arm CROSS_COMPILE=$(PREFIX)

uboot:
	cd $(WS)/u-boot-2010.09 && make ARCH=arm distclean
	cd $(WS)/u-boot-2010.09 && ./make_config
	cd $(WS)/u-boot-2010.09 && make ARCH=arm CROSS_COMPILE=$(PREFIX)


# Clean
clean_all:
	rm -rf $(WS)/buildroot-2010.08/dl \
		$(WS)/buildroot-2010.08/output

clean_kernel:
	cd $(WS)/linux-2.6.36-rc6 && make clean ARCH=arm

clean_uboot:
	cd $(WS)/u-boot-2010.09 && make ARCH=arm distclean \
		CROSS_COMPILE=$(PREFIX)


	
