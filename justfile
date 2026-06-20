image := "zmk"

default:
    @just --list


# Enter build environment(podman)
enter-build:
    @podman run -it --rm --security-opt label=disable --workdir /workspaces/zmk \
        -v ../../zmkfirmware/zmk/:/workspaces/zmk \
        -v .:/workspaces/zmk-modules \
        -v ./boards/shields/ergo_nexus:/workspaces/zmk-config \
        -v ./.docker/.bash_history:/root/.bash_history \
        -v ./.docker/extra_modules/:/workspaces/extra-modules \
        -p 3000:3000 \
        {{image}} /bin/bash
        
# build environment(podman)
_exec-command-in-build-container command:
    @podman run --rm --security-opt label=disable --workdir /workspaces/zmk/app \
        -v ../../zmkfirmware/zmk/:/workspaces/zmk \
        -v .:/workspaces/zmk-modules \
        -v ./boards/shields/ergo_nexus:/workspaces/zmk-config \
        -v ./.docker/.bash_history:/root/.bash_history \
        -v ./.docker/extra_modules/:/workspaces/extra-modules \
        -p 3000:3000 \
        {{image}} \
        {{command}}

# build left firmware
build-left: (_exec-command-in-build-container 'west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_left.uf2
# build right firmware
build-right: (_exec-command-in-build-container 'west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -- -DSHIELD=ergo_nexus_right -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_right.uf2

# build left firmware with debug
build-left-usb: (_exec-command-in-build-container 'west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -S zmk-usb-logging -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_left_usb.uf2
# build right firmware with debug
build-right-usb: (_exec-command-in-build-container 'west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -S zmk-usb-logging -- -DSHIELD=ergo_nexus_right -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_right_usb.uf2
# build reset firmware
build-reset: (_exec-command-in-build-container 'west build -p -b nice_nano//zmk -- -DSHIELD=settings_reset')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./settings_reset.uf2

# copy fimware to device
copyto-device file:
    sudo mount /dev/sdb /mnt
    sudo cp {{file}} /mnt
    sleep 5
    sudo umount /mnt
