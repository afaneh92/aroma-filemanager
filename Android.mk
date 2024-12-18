LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

# LOCAL PATH COPY
AROMA_FILEMANAGER_LOCALPATH := $(LOCAL_PATH)

# Check for ARM NEON
AROMA_ARM_NEON := false
ifeq ($(ARCH_ARM_HAVE_NEON),true)
    AROMA_ARM_NEON := true
endif

# VERSIONING
AROMA_NAME := AROMA Filemanager
AROMA_VERSION := 1.92
AROMA_BUILD := $(shell date +%y%m%d%H)
AROMA_CN := Degung Gamelan

# MINUTF8 SOURCE FILES
LOCAL_SRC_FILES += \
    libs/minutf8/minutf8.c

# FREETYPE SOURCE FILES
LOCAL_SRC_FILES += \
    libs/freetype/autofit/autofit.c \
    libs/freetype/base/basepic.c \
    libs/freetype/base/ftapi.c \
    libs/freetype/base/ftbase.c \
    libs/freetype/base/ftbbox.c \
    libs/freetype/base/ftbitmap.c \
    libs/freetype/base/ftglyph.c \
    libs/freetype/base/ftinit.c \
    libs/freetype/base/ftpic.c \
    libs/freetype/base/ftstroke.c \
    libs/freetype/base/ftsynth.c \
    libs/freetype/base/ftsystem.c \
    libs/freetype/cff/cff.c \
    libs/freetype/pshinter/pshinter.c \
    libs/freetype/psnames/psnames.c \
    libs/freetype/raster/raster.c \
    libs/freetype/sfnt/sfnt.c \
    libs/freetype/smooth/smooth.c \
    libs/freetype/truetype/truetype.c \
    libs/freetype/base/ftlcdfil.c

# AROMA CONTROLS SOURCE FILES
LOCAL_SRC_FILES += \
    src/controls/aroma_controls.c \
    src/controls/aroma_control_button.c \
    src/controls/aroma_control_check.c \
    src/controls/aroma_control_checkbox.c \
    src/controls/aroma_control_console.c \
    src/controls/aroma_control_edit.c \
    src/controls/aroma_control_filebox.c \
    src/controls/aroma_control_ime.c \
    src/controls/aroma_control_ime2.c \
    src/controls/aroma_control_imgbutton.c \
    src/controls/aroma_control_label.c \
    src/controls/aroma_control_menubox.c \
    src/controls/aroma_control_optbox.c \
    src/controls/aroma_control_progress.c \
    src/controls/aroma_control_textbox.c \
    src/controls/aroma_control_threads.c

# AROMA LIBRARIES SOURCE FILES
LOCAL_SRC_FILES += \
    src/libs/aroma_array.c \
    src/libs/aroma_freetype.c \
    src/libs/aroma_graph.c \
    src/libs/aroma_input.c \
    src/libs/aroma_languages.c \
    src/libs/aroma_libs.c \
    src/libs/aroma_memory.c \
    src/libs/aroma_png.c \
    src/libs/aroma_zip.c

# AROMA FILEMANAGER SOURCE FILES
LOCAL_SRC_FILES += \
    src/main/aroma.c \
    src/main/aroma_ui.c

# MODULE SETTINGS
LOCAL_MODULE := aroma_filemanager
LOCAL_MODULE_PATH := $(PRODUCT_OUT)
LOCAL_MODULE_TAGS := eng
LOCAL_FORCE_STATIC_EXECUTABLE := true

# INCLUDES
LOCAL_C_INCLUDES := \
    $(AROMA_FILEMANAGER_LOCALPATH)/include \
    $(AROMA_FILEMANAGER_LOCALPATH)/src \
    external/png \
    bootable/recovery

# COMPILER FLAGS
LOCAL_CFLAGS := -O2 
LOCAL_CFLAGS += -DFT2_BUILD_LIBRARY=1 -DDARWIN_NO_CARBON 
LOCAL_CFLAGS += -fdata-sections -ffunction-sections
LOCAL_CFLAGS += -Wl,--gc-sections -fPIC -DPIC
LOCAL_CFLAGS += -D_AROMA_NODEBUG

ifeq ($(AROMA_ARM_NEON),true)
    LOCAL_CFLAGS += -mfloat-abi=softfp -mfpu=neon -D__ARM_HAVE_NEON
endif

# SET VERSION
LOCAL_CFLAGS += -DAROMA_NAME="\"$(AROMA_NAME)\""
LOCAL_CFLAGS += -DAROMA_VERSION="\"$(AROMA_VERSION)\""
LOCAL_CFLAGS += -DAROMA_BUILD="\"$(AROMA_BUILD)\""
LOCAL_CFLAGS += -DAROMA_BUILD_CN="\"$(AROMA_CN)\""

# INCLUDED LIBRARIES
LOCAL_STATIC_LIBRARIES := libpng libminzip libm libc libz
  
# Remove Old Build
ifeq ($(MAKECMDGOALS),$(LOCAL_MODULE))
    $(shell rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES/$(LOCAL_MODULE)_intermediates)
    $(shell rm -rf $(PRODUCT_OUT)/aroma-fm.zip)
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

AROMA_ZIP_TARGET := $(PRODUCT_OUT)/aroma-fm.zip
$(AROMA_ZIP_TARGET):
	@echo "----- Making aroma filemanager zip ------"
	$(hide) rm -rf $(PRODUCT_OUT)/assets
	$(hide) rm -rf $(PRODUCT_OUT)/aroma-fm.zip
	$(hide) cp -R $(AROMA_FILEMANAGER_LOCALPATH)/assets/ $(PRODUCT_OUT)/assets/
	$(hide) cp $(PRODUCT_OUT)/aroma_filemanager $(PRODUCT_OUT)/assets/META-INF/com/google/android/update-binary
	$(hide) pushd $(PRODUCT_OUT)/assets/ && zip -r9 ../aroma-fm.zip . && popd
	@echo "Made flashable aroma-fm.zip: $@"

.PHONY: aroma_filemanager_zip
aroma_filemanager_zip: $(AROMA_ZIP_TARGET)
