#!/usr/bin/env bash

VAR=$(pgrep evolution -l | grep -Eiv "evolution-")

if [ "$VAR" ]
then
    kill "$(echo "$VAR" | grep -Eo '^[^ ]+')";
else
    evolution & disown;
fi
exit
