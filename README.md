# zmk-config-ErgoNexus

自作分割キーボード **ErgoNexus** 用の ZMK Firmware 設定リポジトリ（zmk-config）です。

## 概要

- **キーボード名**: ErgoNexus
- **対応コントローラー (MCU)**: `nice!nano` (および互換ボード)
- **特徴**:
  - 左右分割型キーボード
  - ロータリーエンコーダー（ALPS EC11など）による入力サポート
  - `podman` / `Docker` を用いたポータブルなローカルビルド環境

---

## リポジトリ構成

```text
├── boards/
│   └── shields/
│       └── ergo_nexus/             # ErgoNexus シールド定義
│           ├── Kconfig.defconfig
│           ├── Kconfig.shield
│           ├── ergo_nexus.conf
│           ├── ergo_nexus.dtsi     # エンコーダーや基本ハードウェア定義
│           ├── ergo_nexus.keymap   # キーマップ定義
│           ├── ergo_nexus.zmk.yml
│           ├── ergo_nexus_left.conf
│           ├── ergo_nexus_left.overlay
│           ├── ergo_nexus_right.conf
│           └── ergo_nexus_right.overlay
├── justfile                        # ビルド・タスクランナー設定
├── ergo_nexus_left.uf2             # ビルド済みの左側ファームウェア
├── ergo_nexus_right.uf2            # ビルド済みの右側ファームウェア
└── settings_reset.uf2              # Bluetooth接続リセット用ファームウェア
```

---

## ビルド環境のセットアップ

本リポジトリでは、ビルド自動化ツール [just](https://github.com/casey/just) と [podman](https://podman.io/) (または Docker) を使用して、PCを汚さずにファームウェアをビルドする環境が整えられています。

### 前提条件

以下のツールを事前にインストールしてください。

- `just` (タスクランナー)
- `podman` (推奨) または `Docker`

---

## ファームウェアのビルド方法

`just` コマンドを使用して、簡単にビルドを実行できます。

### 1. 左側 (Left) ファームウェアのビルド
```bash
just build-left
```
ビルドが完了すると、リポジトリのルートに `ergo_nexus_left.uf2` が生成されます。

### 2. 右側 (Right) ファームウェアのビルド
```bash
just build-right
```
ビルドが完了すると、リポジトリのルートに `ergo_nexus_right.uf2` が生成されます。

### 3. デバッグ用（USBロギング有効）のビルド
開発時やキー入力・エンコーダーの動作デバッグ時に使用します。
```bash
# 左側
just build-left-usb

# 右側
just build-right-usb
```
それぞれ `ergo_nexus_left_usb.uf2`, `ergo_nexus_right_usb.uf2` が生成されます。

### 4. 接続リセット用ファームウェアのビルド
Bluetoothのペアリング情報をクリアしたい場合などに使用します。
```bash
just build-reset
```
`settings_reset.uf2` が生成されます。

---

## デバイスへの書き込み方法

1. `nice!nano` をPCにUSB接続し、ダブルクリックでブートローダーモード（USBマスストレージとして認識される状態）にします。
2. 以下のコマンド、またはドラッグ＆ドロップで生成された `.uf2` ファイルをデバイスへ書き込みます。

`justfile` の自動マウント・コピー機能を使用する場合：
```bash
just copyto-device ergo_nexus_left.uf2
```
*(※ `/dev/sdb` を `/mnt` にマウントして書き込む設定になっているため、環境に応じて `justfile` 内のデバイスパスを調整してください)*

---

## 主なカスタマイズ

### キーマップの変更
`boards/shields/ergo_nexus/ergo_nexus.keymap` をテキストエディタで開き、お好みのキーレイアウトに変更します。変更後は再度 `just build-left` や `just build-right` を実行してビルドしてください。

### ロータリーエンコーダーの調整
`boards/shields/ergo_nexus/ergo_nexus.dtsi` 内の `rotary_encoder` ノードで、エンコーダーのステップ数や感度を調整できます。

```dts
rotary_encoder: rotary_encoder {
    compatible = "alps,ec11";
    a-gpios = <&gpio0 22 (GPIO_ACTIVE_HIGH | GPIO_PULL_UP)>;
    b-gpios = <&gpio0 24 (GPIO_ACTIVE_HIGH | GPIO_PULL_UP)>;
    steps = <24>; // 1回転あたりの物理ステップ数
    status = "okay";
};
```
