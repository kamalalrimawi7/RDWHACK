DEBUG = 0
FINALPACKAGE = 1
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KreaPro
KreaPro_FILES = Tweak.x
KreaPro_CFLAGS = -fobjc-arc
KreaPro_FRAMEWORKS = UIKit Foundation
KreaPro_LIBRARIES = flex

include $(THEOS_MAKE_PATH)/tweak.mk
