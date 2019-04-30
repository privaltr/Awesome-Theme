#!/usr/bin/env bash
#requires slop
read -r X Y W H < <(slop -f "%x %y %w %h" -b 1 -t 0 -q)
(( W /= 8 ))
(( H /= 16 ))

#W=`expr $W - 3`
#H=`expr $H - 1`

W=$(( W - 3))
H=$(( H - 3))

g=${W}x${H}+${X}+${Y}
echo "$g"
urxvt -g "$g" -name floating
