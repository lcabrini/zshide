info() {
    print "$fg[green]I: $1$reset_color" > /dev/stderr
}

warn() {
    print "$fg[yellow]W: $1$reset_color" > /dev/stderr
}

err() {
    print "$fg[red]E: $1$reset_color" > /dev/stderr
}