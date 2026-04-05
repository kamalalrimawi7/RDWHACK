TARGET := iphone:clang:latest:14.5
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RDWHACK
RDWHACK_FILES = Tweak.x
RDWHACK_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
