# fish theme: simple

function _is_head_detached
    command git symbolic-ref -q HEAD > /dev/null 2>&1
    echo $status
end

function _git_branch_name
    if test (_is_head_detached) = 0
        echo (command git symbolic-ref HEAD 2> /dev/null | sed -e "s|^refs/heads/||")
    else
        echo "detached at "(command git rev-parse --short HEAD 2> /dev/null)
    end
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _short_cwd
    set path_splits (string split / (prompt_pwd))

    set final_path ""
    set i 0

    for d in (string split / (prompt_pwd))
        set d_char (echo $d | grep -oE "^[^a-zA-Z0-9~]*[a-zA-Z0-9~]{1}")

        if test $i = (math (string join \n $path_splits | wc -l) - 1) -a "$d" != ""
            set d_char (basename (prompt_pwd))
        end

        if test $i = 0
            set final_path "$d_char"
        else
            set final_path "$final_path/$d_char"
        end

        set i (math $i + 1)
    end

    echo $final_path
end

function fish_prompt
    set -l last_status $status
    set fish_greeting
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l green_light (set_color green)
    set -l normal (set_color normal)

    set -l cwd $cyan(_short_cwd)

    # output the prompt, left to right:
    # display "user@host:"
    echo -n -s $green_light (whoami) $green "@" (hostname | cut -d . -f 1) ": "

    # display the current directory name:
    echo -n -s $cwd $normal

    # show git branch and dirty state, if applicable:
    if [ (_git_branch_name) ]
        set -l git_branch "[" (_git_branch_name) "]"

        if [ (_is_git_dirty) ]
            set git_info $red $git_branch "×"
        else
            set git_info $green $git_branch
        end
        echo -n -s " " $git_info $normal
    end

    # terminate with a nice prompt char:
    if test $last_status -ne 0
        echo -n -s $red
    else
        echo -n -s $normal
    end
    echo -n -s " 〉" $normal
end
