DEBUG = 0
FINALPACKAGE = 1
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KreaProBypass
KreaProBypass_FILES = Tweak.x
KreaProBypass_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

