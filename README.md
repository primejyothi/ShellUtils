ShellUtils
========

Some random shell scripts written to make my life bit easier.

### push & pop
Shows a numbered list of saved directories and cd to the selected directory. Push will remember the current directory and pop[1] will cd to the selected directory.
Create two aliases as follows :
alias pop='. ~/bin/pop.sh'
alias push='~/bin/push.sh'
[1] In order to cd, the pop script will have to be executed in the current shell. 
