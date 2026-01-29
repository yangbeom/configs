# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

source ~/github/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias vi="nvim"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

export EDITOR="/opt/homebrew/bin/nvim"

. "$HOME/.local/bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yangbeom/.lmstudio/bin"
# End of LM Studio CLI section

# 단어 단위 이동
bindkey '\eb' backward-word
bindkey '\ef' forward-word

# 줄 시작/끝
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line
