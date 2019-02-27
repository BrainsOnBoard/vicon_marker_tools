ifndef USE_LOCAL_BOB_ROBOTICS
	BOB_ROBOTICS_PATH := bob_robotics
endif
WITH_MATPLOTLIBCPP := 1
include $(BOB_ROBOTICS_PATH)/make_common/bob_robotics.mk

VICON_DATASTREAM_SDK_ROOT := vicon_data_stream_sdk
CXXFLAGS += -I$(VICON_DATASTREAM_SDK_ROOT)/Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP
LINK_FLAGS += -L$(VICON_DATASTREAM_SDK_ROOT)/bin/Release \
		-lViconDataStreamSDK_CPP \
		-Wl,-rpath,$(VICON_DATASTREAM_SDK_ROOT)/bin/Release,--disable-new-dtags

EXECUTABLE := save_object

.PHONY: all clean vicon_data_stream_sdk gitsubmodules

all: $(EXECUTABLE)

-include $(EXECUTABLE).d

$(EXECUTABLE): $(EXECUTABLE).cc $(EXECUTABLE).d vicon_data_stream_sdk gitsubmodules
	$(CXX) -o $@ $< $(CXXFLAGS) $(LINK_FLAGS)

vicon_data_stream_sdk: gitsubmodules
	CONFIG=Release $(MAKE) -C $(VICON_DATASTREAM_SDK_ROOT)

gitsubmodules:
	git submodule update --init $(VICON_DATASTREAM_SDK_ROOT)
ifdef USE_LOCAL_BOB_ROBOTICS
	@echo !!! USING LOCAL BOB ROBOTICS REPO !!!
else
	git submodule update --init $(BOB_ROBOTICS_PATH)
endif

%.d: ;

clean:
	rm -f $(EXECUTABLE) *.d
