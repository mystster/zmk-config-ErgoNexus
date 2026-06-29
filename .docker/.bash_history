ls ../zmk-modules/
cd build/
ls
cd ..
ls ../zmk-config/
exit
ls
cd app/build/zephyr
ls
exit
ls -al app/build/zephyr
date
exit
ls
cd build/
ls
cd ..
west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/work
     │ spaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"
cd app
west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/work
     │ spaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"
west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"
cd build/zephyr/.config 
cat build/zephyr/.config 
ls
cd build/
ls
cd ..
west build -p -b nice_nano//zmk -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DZMK_CONFIG="/workspaces/zmk-config/"
cat build/zephyr/zephyr.dts
cat build/zephyr/zephyr.dts.d
cat build/zephyr/zephyr.dts.pre 
less build/zephyr/zephyr.dts.pre 
exit
ls
ls modules/
exit
cd ..
ls
ls extra-modules/
ls extra-modules/zmk-rgbled-widget/
ls extra-modules/zmk-rgbled-widget/boards/
ls extra-modules/zmk-rgbled-widget/boards/shields/
exit
cd /workspaces/extra-modules/zmk-rgbled-widget/
xit
helix ju
exit
cd app
west config build.cmake-args -- -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
exit
cd app
[200~west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -- -DSHIELD=ergo_nexus_left -DZ
     │ MK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/;/workspaces/extra-modules/prospector-zmk-modu
[200~west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -- -DSHIELD=ergo_nexus_left -DZ
     │ MK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/;/workspaces/extra-modules/prospector-zmk-modu
vi
exit
cd app
west build -p -b nice_nano//zmk -S studio-rpc-usb-uart -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/;/workspaces/extra-modules/zmk-rgbled-widget/;/workspaces/extra-modules/prospector-zmk-module/" -DZMK_CONFIG="/workspaces/zmk-config/"
ls build/
cat build/compile_commands.json 
exit
