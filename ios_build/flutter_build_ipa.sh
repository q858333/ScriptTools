#!/bin/bash
# iOS IPA 构建脚本
# 1 -> Ad Hoc；2 -> Release（商店包，见 flutter build ipa 说明）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "请选择打包类型："
echo "  1) Ad Hoc（flutter build ipa --export-method ad-hoc）"
echo "  2) 商店包（flutter build ipa --release）"
read -r -p "请输入 1 或 2: " choice

case "$choice" in
  1)
    echo ""
    echo "===== 开始构建 Ad Hoc IPA ====="
    flutter build ipa --export-method ad-hoc
    ;;
  2)
    echo ""
    echo "===== 开始构建 Release（商店）IPA ====="
    flutter build ipa --release
    ;;
  *)
    echo "错误: 无效选择，请输入 1 或 2"
    exit 1
    ;;
esac

IPA_DIR="${SCRIPT_DIR}/build/ios/ipa"
IPA_FILE=""
if [ -d "$IPA_DIR" ]; then
  IPA_FILE="$(find "$IPA_DIR" -maxdepth 1 -name "*.ipa" -type f | head -n 1)"
fi

echo ""
echo "===== 构建完成 ====="
if [ -n "$IPA_FILE" ] && [ -f "$IPA_FILE" ]; then
  echo "IPA 路径: $IPA_FILE"
  # 在 Finder 中打开 ipa 所在目录并选中该文件
  open -R "$IPA_FILE"
  # macOS 系统通知（正文中的路径做简单转义，避免引号/反斜杠导致 osascript 失败）
  _NOTIFY_BODY=$(printf '%s' "$IPA_FILE" | sed 's/\\/\\\\/g; s/"/\\"/g')
  osascript -e "display notification \"${_NOTIFY_BODY}\" with title \"iOS 打包完成\""
else
  echo "未在 ${IPA_DIR} 下找到 .ipa 文件，请到 Xcode / build 目录确认产物。"
  osascript -e 'display notification "未找到 ipa 文件，请查看终端输出" with title "iOS 打包结束"'
fi
