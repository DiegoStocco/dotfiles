if status is-interactive
    set -gx EDITOR 'nvim'

    alias ls='ls --color=auto'
    alias l='ls --color=auto'
    alias ll='ls --color=auto -lh'
    alias grep='grep --color=auto'
    alias o='xdg-open'
    alias nivm='nvim'
    alias v='nvim'
    alias sv='sudo -e'
    alias neofetch='fastfetch'
    alias :q='exit'

    abbr ccp 'g++ -Wall -Wextra -Wfloat-equal -Wshadow -pedantic -I$HOME/.local/include -Og -g -fsanitize=address,undefined -fstack-protector-strong -fno-omit-frame-pointer -fno-sanitize-recover=all -std=c++23 -DLOCAL'

end
