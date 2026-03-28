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
exec-command-in-build-container command:
    @podman run --rm --security-opt label=disable --workdir /workspaces/zmk/app \
        -v ../../zmkfirmware/zmk/:/workspaces/zmk \
        -v .:/workspaces/zmk-modules \
        -v ./boards/shields/ergo_nexus:/workspaces/zmk-config \
        -v ./.docker/.bash_history:/root/.bash_history \
        -v ./.docker/extra_modules/:/workspaces/extra-modules \
        -p 3000:3000 \
        {{image}} \
        {{command}}

build-left: (exec-command-in-build-container 'west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_left.uf2
build-right: (exec-command-in-build-container 'west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_right -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_right.uf2
build-left-usb: (exec-command-in-build-container 'west build -p -b nice_nano//zmk -S zmk-usb-logging -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_left_usb.uf2
build-right-usb: (exec-command-in-build-container 'west build -p -b nice_nano//zmk -S zmk-usb-logging -- -DSHIELD=ergo_nexus_right -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./ergo_nexus_right_usb.uf2
build-reset: (exec-command-in-build-container 'west build -p -b nice_nano//zmk -- -DSHIELD=settings_reset')
    cp ../../zmkfirmware/zmk/app/build/zephyr/zmk.uf2 ./settings_reset.uf2
copyto-device file:
    sudo mount /dev/sdb /mnt
    sudo cp {{file}} /mnt
    sleep 5
    sudo umount /mnt
