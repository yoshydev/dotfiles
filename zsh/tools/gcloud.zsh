# Google Cloud SDK

# PATH設定
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then
  source "${HOME}/google-cloud-sdk/path.zsh.inc"
fi

# コマンド補完
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then
  source "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi
