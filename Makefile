export SIGNING_REQUIRED = 0
export CODESIGN = true

ARCHS = arm64
TARGET = iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RDWHACK
RDWHACK_FILES = Tweak.x
RDWHACK_CFLAGS = -fobjc-arc
RDWHACK_LDFLAGS = -fuse-ld=lld

include $(THEOS_MAKE_PATH)/tweak.mk
