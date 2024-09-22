# Path to your oh-my-zsh installation.
source $ZSH/oh-my-zsh.sh

# Add this near the top of your .zshrc file
export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:$PATH" 
alias c='clear' #clear terminal alias 
alias l='eza -lh  --icons=auto' # long list alias 
alias ls='eza -1   --icons=auto' # short list alias 
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all alias 
alias ld='eza -lhD --icons=auto' # long list dirs alias 
alias lt='eza --icons=auto --tree' # list folder as tree # Handy change dir shortcuts 
alias ..='cd ..' 
alias ...='cd ../..' 
alias .3='cd ../../..' 
alias .4='cd ../../../..' 
alias .5='cd ../../../../..' # Always mkdir a path (this doesn't inhibit functionality to make a single dir) alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Display Pokemon
pokemon-colorscripts --no-title -r 1-3