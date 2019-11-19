autoload -U colors
colors

function info() {
    print "$fg[green]I: $1$reset_color" > /dev/stderr
}

function warn() {
    print "$fg[yellow]W: $1$reset_color" > /dev/stderr
}

function err() {
    print "$fg[red]E: $1$reset_color" > /dev/stderr
}
