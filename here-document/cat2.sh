#!/bin/bash

# By default, behavior is largely identical to the contents of double quotes.
# i.e. variables are interpolated, commands in backticks are evaluated, etc.

# This can be disabled by quoting any part of the label, which is then ended by the unquoted value.
cat << 'EOF'
\$ Working dir "$PWD" `pwd`
EOF
