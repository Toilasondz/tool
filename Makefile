ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = Video Star

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HVSonTool
HVSonTool_FILES = HVSonTweak.m HVSonMenu.m
HVSonTool_CFLAGS = -fobjc-arc
HVSonTool_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
