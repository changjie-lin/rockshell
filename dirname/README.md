__How to get the current present working directory of a bash script from within the script?__

The ccurrent known accurate command is:

`dirname $(readlink -f "$0")`

> This is an executable test for the most rated answer of the [stackoverflow question][SO]
>
> It is actually a fork of the [Gist](https://gist.github.com/tvlooy/cbfbdb111a4ebad8b93e)

[SO]: http://stackoverflow.com/questions/59895/getting-the-current-present-working-directory-of-a-bash-script-from-within-the-s?page=1&tab=votes#tab-top
