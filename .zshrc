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

# Palace Night palette override for p10k (kept in repo, not in ~/.p10k.zsh)
typeset -g POWERLEVEL9K_RULER_FOREGROUND=60
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=60
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=108
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=131
typeset -g POWERLEVEL9K_DIR_FOREGROUND=110
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=146
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=109
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=108
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=60
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=108
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=109
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=179
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=108
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=108
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=131
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=131
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=131
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=179
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=109
typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=179
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=180
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=180
typeset -g POWERLEVEL9K_TIME_FOREGROUND=109
(( $+functions[p10k] )) && p10k reload

alias vi="nvim"

# Palace Night palette for shell UI (matches tmux/ghostty)
typeset -g PALACE_SHELL_LS_COLORS='di=38;5;109:ln=38;5;110:so=38;5;180:pi=38;5;174:ex=38;5;108:bd=38;5;179:cd=38;5;179:su=38;5;174:sg=38;5;174:tw=38;5;60:ow=38;5;60:st=38;5;60'
export LS_COLORS="$PALACE_SHELL_LS_COLORS"
export ZLS_COLORS="$PALACE_SHELL_LS_COLORS"
zstyle ':completion:*' list-colors ${(s.:.)PALACE_SHELL_LS_COLORS}

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'

export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--color=bg:#1f2335,bg+:#2a3048,fg:#a9b1d6,fg+:#c0caf5,hl:#d5b26f,hl+:#6ea08b,info:#9aa5ce,marker:#d5b26f,pointer:#6ea08b,prompt:#7d8fb0,spinner:#d5b26f,header:#565f89,border:#3b4261"

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
