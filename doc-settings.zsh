autoload -U colors
colors

cat <<EOF
$fg_bold[white]GITHUB$reset_color

$fg[yellow]GITHUB_TOKEN$reset_color
Your GitHub token. This is required for all GitHub interaction. You can
create/mangage your token(s) here: https://github.com/settings/tokens.

Notice that to be able to use all the GitHub functionality of zshide,
you need to to have the delete_repo, repo and user scopes enabled.

$fg[yellow]GITHUB_LOGIN$reset_color
Your GitHub username. This will be set automatically for you if you have
set GITHUB_TOKEN properly. If something is wrong, delete this setting
from your settings file and it should be recreated.

$fg[yellow]UPDATE_GITHUB_USERSTATUS$reset_color
Set this to "no" to prevent zshide from updating your user status on
GitHub, or "yes" to allow it. 

$fg[green]Default:$reset_color "no"
EOF
