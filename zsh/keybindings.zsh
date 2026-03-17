# キーバインド設定
# プラグインによる上書きを復元するため、プラグイン後に読み込む

# history-search-multi-word等のプラグインが^E/^Fをself-insertに上書きするため復元
bindkey '^E' end-of-line
bindkey '^F' forward-char
