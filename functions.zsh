function info() {
    print "$fg[green]I: $1$reset_color"
}

function warn() {
    print "$fg[yellow]W: $1$reset_color"
}

function err() {
    print "$fg[red]E: $1$reset_color"
}
