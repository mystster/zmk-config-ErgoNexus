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
        zmk-kleinpad /bin/bash
        
# build environment(podman)
exec-command-in-build-container command:
    @podman run --rm --security-opt label=disable --workdir /workspaces/zmk/app \
        -v ../../zmkfirmware/zmk/:/workspaces/zmk \
        -v .:/workspaces/zmk-modules \
        -v ./boards/shields/ergo_nexus:/workspaces/zmk-config \
        -v ./.docker/.bash_history:/root/.bash_history \
        -v ./.docker/extra_modules/:/workspaces/extra-modules \
        -p 3000:3000 \
        zmk-kleinpad \
        {{command}}

build-left: (exec-command-in-build-container 'west build -p -b nice_nano -- -DSHIELD=ergo_nexus_left -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DAMK_CONFIG="/workspaces/zmk-config/"')
build-right: (exec-command-in-build-container 'west build -p -b nice_nano -- -DSHIELD=ergo_nexus_right -DZMK_EXTRA_MODULES="/workspaces/zmk-modules/" -DAMK_CONFIG="/workspaces/zmk-config/"')
   
# 特定のイメージから設定ファイル(config.yaml)をカレントディレクトリにコピー
cp-fw output="kleinpad.uf2":
    @container=$(podman ps --filter "ancestor={{image}}" --format "{{{{.ID}}"); \
    if [ -n "$container" ]; then \
        podman cp "$container":/workspaces/zmk/app/build/zephyr/zmk.uf2 ./{{output}}; \
        echo "Successfully copied fw from $container"; \
    fi

# podmanのボリュームを作成
create-volume name path:
    @volume=$(podman volume ls --filter "name={{name}}" --format {{{{.Name}})
    if [ -n "$volume" ]; then\
        @podman volume rm {{name}}
    fi
    podman volume create --driver local \
        -o o=bind \
        -o type=none \
        -o device="{{path}}" {{name}}
