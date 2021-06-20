# fish theme: simple

function fish_right_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l red (set_color -o red)
    set -l normal (set_color normal)
    set -l bg_processes (jobs -p | wc -l)

    # print number of bg processes running if nonzero
    if test $bg_processes -ne 0
        set_color cyan
        echo -n -s "$bg_processes&"
        set_color normal
    end

    # print last exit code if nonzero
    if test $last_status -ne 0
        set_color red
        echo -n -s " -$last_status-"
        set_color normal
    end

    # display the timestamp on the utmost right
    echo -n -s $normal " [" (date +%H:%M:%S) "]"
end
