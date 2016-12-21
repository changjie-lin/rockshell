#!/bin/bash

# By default, behavior is largely identical to the contents of double quotes.
# i.e. variables are interpolated, commands in backticks are evaluated, etc.

cat << EOF
\$ Working dir "$PWD" `pwd`
EOF
