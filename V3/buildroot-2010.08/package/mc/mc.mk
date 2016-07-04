#############################################################
#
# mc-mp
#
#############################################################
MC_VERSION = 4.1.40-pre9
MC_SOURCE = mc-$(MC_VERSION).tar.bz2
MC_SITE = http://mc.linuxinside.com/Releases/
MC_LIBTOOL_PATCH = NO
MC_CONF_OPT = --prefix=/usr --disable-nls --without-gpm-mouse --with-ext2undel
MC_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
#MC_DEPENDENCIES = 

$(eval $(call AUTOTARGETS,package,mc))
