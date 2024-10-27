#!/bin/bash

FACTORIO_PATH="/opt/factorio"
CURRENT_VERSION=$($FACTORIO_PATH/bin/x64/factorio --version | head -n 1 | cut -d ' ' -f 2)
echo "当前版本: $CURRENT_VERSION"

if [[ "$1" == "--latest" ]];then
    echo "开始更新到最新版本"
    VERSION_NUM="latest"
else
    HTML=$(curl -s https://www.factorio.com/download/archive/)
    VERSIONS=$(echo "$HTML" | grep -Eo 'href="/download/archive/[0-9.]*"' | sed -E 's/href="\/download\/archive\/([0-9.]*)"/\1/g')

    if [ -z "$VERSIONS" ]; then
        echo "获取最新版本失败"
        exit 1
    fi

    echo "可供下载的版本有:"
    echo "$VERSIONS"
    echo "其实你也可以直接输入 latest 来下载最新版"

    read VERSION_NUM
fi

TAR_FILE="factorio_${VERSION_NUM}_linux64.tar.xz"
wget -O "$TAR_FILE" "https://www.factorio.com/get-download/$VERSION_NUM/headless/linux64"

if [ $? -ne 0 ]; then
    echo "下载失败"
    rm -f "$TAR_FILE"
    exit 1
fi

echo "开始解压"
tar -xf "$TAR_FILE" --directory "$FACTORIO_PATH"
if [ $? -ne 0 ]; then
    echo "解压失败"
    rm -f "$TAR_FILE"
    exit 1
fi

rm -f "$TAR_FILE"