CXX = g++
CXXFLAGS = -fPIC --no-gnu-unique -Isrc/ -g `pkg-config --cflags pixman-1 libdrm hyprland hyprlang` -std=c++2b -DWLR_USE_UNSTABLE



all:
	mkdir -p out
	$(CXX) -shared -fPIC --no-gnu-unique src/*.cpp -Isrc/ -o out/hyprchroma.so -g `pkg-config --cflags pixman-1 libdrm hyprland hyprlang` -std=c++2b -DWLR_USE_UNSTABLE

build-version:
	mkdir -p "out/$(VERSION)" 
	$(CXX) -shared -fPIC --no-gnu-unique src/*.cpp -Isrc/ -I"hyprland/$(VERSION)/include/hyprland/protocols" -I"hyprland/$(VERSION)/include/hyprland/wlroots" -I"hyprland/$(VERSION)/include/" -o "out/$(VERSION)/hyprchroma.so" -g `pkg-config --cflags pixman-1 libdrm` -std=c++2b -DWLR_USE_UNSTABLE


clean:
	rm -rf out

load: unload

	hyprctl plugin load $(shell pwd)/out/$(VERSION)/hyprchroma.so

unload:
	hyprctl plugin unload $(shell pwd)/out/$(VERSION)/hyprchroma.so

setup-dev:
ifeq ("$(wildcard hyprland/$(VERSION))","")
	mkdir -p "hyprland/$(VERSION)"
	git clone https://github.com/hyprwm/Hyprland "hyprland/$(VERSION)"
	cd "hyprland/$(VERSION)" && git checkout "$(VERSION)" && git submodule update --init
endif
	cd "hyprland/$(VERSION)" && make debug && make installheaders PREFIX="."

setup-headers:
ifeq ("$(wildcard hyprland/$(VERSION))","")
	mkdir -p "hyprland/$(VERSION)"
	git clone https://github.com/hyprwm/Hyprland "hyprland/$(VERSION)"
	cd "hyprland/$(VERSION)" && git checkout "$(VERSION)" && git submodule update --init
endif
	cd "hyprland/$(VERSION)" && make all && make installheaders PREFIX="`pwd`"

dev:
	hyprland/$(VERSION)/build/Hyprland

