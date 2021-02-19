# filter the possible local branch names for mbd script
_mbd_script_branch_complete() {
	branches=$(git branch -l | cut -c3-)
	COMPREPLY=($(compgen -W "$branches" -- "$2"))
}

# register the handler for mbd-switch command
complete -F _mbd_script_branch_complete mbd-switch mbd-switch-hard
