#titico vim config
## Installation and Setup

Be sure you are on your home directory: `cd ~`

`git clone   git://github.com/titico/.vim.git` 

Finally run `./vimrc.sh`


##Options
I had to add the line
`let s:known_types.cuda = type_cpp` to get tags when working with CUDA. This will
have to be set up manually everytime because tagbar is in a submodule.
