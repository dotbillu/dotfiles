
source ~/.zshrc.themes

source ~/.zshrc.alias 
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator

export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/26.1.10909125"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
