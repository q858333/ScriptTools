#!/bin/bash
# iOS IPA 构建脚本
# 1 -> Ad Hoc；2 -> Release（商店包，见 flutter build ipa 说明）
#
# 点击通知打开目录：依赖 terminal-notifier（brew install terminal-notifier）
# 系统自带的 osascript display notification 无法绑定点击动作。

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

  IPA_PARENT="$(cd "$(dirname "$IPA_FILE")" && pwd)"

  if command -v terminal-notifier &>/dev/null; then
    # 点击通知：用 file:// 打开目录（terminal-notifier 的 -open 在点击时由系统打开）
    if command -v python3 &>/dev/null; then
      _FILE_URL=$(IPA_PARENT="$IPA_PARENT" python3 -c 'import os; from pathlib import Path; print(Path(os.environ["IPA_PARENT"]).resolve().as_uri())')
      terminal-notifier -title "iOS 打包完成" -message "点击打开 ipa 所在目录" -open "$_FILE_URL"
    else
      _OPEN_CMD="open $(printf '%q' "$IPA_PARENT")"
      terminal-notifier -title "iOS 打包完成" -message "点击打开 ipa 所在目录" -execute "$_OPEN_CMD"
    fi
  else
    _NOTIFY_BODY=$(printf '%s' "$IPA_FILE" | sed 's/\\/\\\\/g; s/"/\\"/g')
    osascript -e "display notification \"${_NOTIFY_BODY}\" with title \"iOS 打包完成\""
    echo ""
    echo "提示: 点击通知打开目录需安装 terminal-notifier：brew install terminal-notifier"
  fi
else
  echo "未在 ${IPA_DIR} 下找到 .ipa 文件，请到 Xcode / build 目录确认产物。"
  osascript -e 'display notification "未找到 ipa 文件，请查看终端输出" with title "iOS 打包结束"'
fi
