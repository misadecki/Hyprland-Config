# 1. Włączanie kolorów i podstaw
autoload -Uz compinit promptinit
compinit
promptinit

# Załaduj moduł listy wyboru (zwykle jest, ale dla pewności)
zmodload zsh/complist

# Włącz menu wyboru (to robi "prostokąt" i pozwala nawigować strzałkami)
zstyle ':completion:*' menu select

# Włącz kolory w liście podpowiedzi (takie same jak komenda ls)
# Dzięki temu prostokąt wyboru będzie widoczny, a pliki kolorowe
autoload -Uz colors && colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Opcjonalnie: Lepsze formatowanie opisów (np. --help)
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'

# 2. Historia (żeby pamiętał komendy po restarcie)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# 3. Znak zachęty (prosty, kolorowy prompt)
# Możesz to zmienić później na powerlevel10k, jeśli chcesz "bajerów"
PROMPT='%F{green}%n@%m%f %F{blue}%~%f $ '

# 4. Ładowanie wtyczek (Kluczowe dla efektu Manjaro!)
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 5. Skróty klawiszowe
bindkey -e              # Standardowe skróty Emacs (Ctrl+A, Ctrl+E itp.)
bindkey '^[[A' up-line-or-search   # Strzałka w górę szuka w historii
bindkey '^[[B' down-line-or-search # Strzałka w dół szuka w historii
# Akceptuj podpowiedź kombinacją Ctrl+Spacja
# bindkey '^ ' autosuggest-accept
#Autosuggest accept second bind: Ctrl+UpArrow
bindkey '^[[1;5A' autosuggest-accept
eval "$(starship init zsh)"
eval "$(dircolors ~/.dircolors)"

#6. Aliasy
alias ls='ls --color=auto'
alias cclear='wl-copy --clear && wl-copy --primary --clear && cliphist wipe'
alias panamint='ssh msadecki@panamint.kcir.pwr.edu.pl'
alias sd='sudo pacman -Syu; flatpak update && poweroff'

# ==========================================
# Konfiguracja FZF-TAB
# ==========================================

# 1. Załaduj wtyczkę (dostosuj ścieżkę jeśli zapisałeś gdzie indziej)
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# 2. Wyłącz domyślne menu wyboru (to stare), aby fzf-tab przejął kontrolę
zstyle ':completion:*' menu no

# 3. Kolory: użyj kolorów z ls (LS_COLORS) w wynikach fzf
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 4. PREVIEW (Najważniejsza część!)
# To sprawia, że widzisz podgląd pliku/katalogu podczas wybierania

# Domyślny podgląd dla plików (używa 'cat' lub lepiej 'bat' jeśli masz)
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'

# Lepszy podgląd przy 'cd': wyświetla zawartość katalogu (używa 'ls' lub 'eza')
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always -1 $realpath'

# Podgląd zmiennych środowiskowych (przy export lub unset)
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# 5. Konfiguracja okna fzf (opcjonalne)
# Ustawia okno na 60% wysokości, podgląd po prawej stronie (40%)
zstyle ':fzf-tab:*' fzf-flags --height=60%
zstyle ':fzf-tab:*' fzf-pad 4

# ==========================================
# 7. Poprawki klawiszy (Keybindings)
# ==========================================

# Obsługa klawisza DELETE
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# Obsługa CTRL + Strzałki (Skakanie po całych słowach)
bindkey '^[[1;5C' forward-word   # Ctrl + Prawo
bindkey '^[[1;5D' backward-word  # Ctrl + Lewo

# Obsługa HOME i END (Dla pewności, bo czasem też nie działają)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ==========================================
# Rozwiązanie dla edycji długich komend
# ==========================================
# Ponieważ Shift+Strzałka nie działa w terminalu tak jak w notatniku,
# najlepszym sposobem na edycję długiej komendy jest otwarcie jej w edytorze.
# Poniższe ustawienie sprawia, że skrót Ctrl+E otwiera obecną komendę w domyślnym edytorze (np. nano lub vim).

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

#Directories shortcuts
hash -d v="/home/cardaver/Work/VI_semester"
export PICO_SDK_PATH=/home/cardaver/Pico/pico-sdk
export EDITOR=nvim
export VISUAL=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/.local/xPacks/@xpack-dev-tools/arm-none-eabi-gcc/15.2.1-1.1.1/.content/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
alias get_idf='. $HOME/software/esp/esp-idf/export.sh'
#Creates idf ESP project same as PlatformIO (need to use template at
#.esp_template)
function idf-new() {
    local project_name=$1
    local template_path="$HOME/.esp_template"

    if [ -z "$project_name" ]; then
        echo "Usage: idf-new project_name"
        return 1
    fi

    if [ ! -d "$template_path" ]; then
        echo "${RED}Error: Template $template_path does not exist!${NC}"
        return 1
    fi

    cp -r "$template_path" "$project_name"
    cd "$project_name"

    # 2. Place project name in CMakeLists.txt
    # (You need to have in CMakeLists.txt: project(project_name_placeholder))
    sed -i "s/project_name_placeholder/$project_name/g" CMakeLists.txt

    echo "Project $project_name created."

    # 3. Nvim init 
    if command -v idf.py &> /dev/null; then
        echo "Generating files for LSP (clangd)..."
        idf.py reconfigure
        #Symlink for compile_commands.json
        ln -sf build/compile_commands.json .
        echo "${GREEN}Your project is ready.${NC}"
    else
        echo "${YELLOW}Problem occuried during creating project.${NC}"
    fi
}
alias otchlan="cd /home/cardaver/software/otchlan && ./otchlan /cp5 && cd -"
export PICO_SDK_PATH="$HOME/software/pico-sdk"

if [ -f /etc/os-release ] && grep -q "Ubuntu" /etc/os-release; then
    export STARSHIP_CONFIG="$HOME/.config/starship_ubuntu.toml"
else
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

alias u="distrobox enter ubuntu"
alias us="distrobox stop ubuntu"
