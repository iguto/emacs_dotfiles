#!/bin/sh
BINSTUB_DIR=.bundle/bin

script_dir=`(cd $(dirname $0); pwd)`


bundle install --path .bundle --binstubs=$BINSTUB_DIR
if [ ! -d $HOME/bin ]; then
  mkdir $HOME/bin
fi
for file in `ls $script_dir/$BINSTUB_DIR`
do
  ln -sf $script_dir/$BINSTUB_DIR/$file $HOME/bin
done


git clone https://github.com/cask/cask.git ~/.cask
if [ ! -d ~/bin ]; then
  echo "directory: ~/bin created."
  mkdir ~/bin
fi
ln -s ~/.cask/bin/cask ~/bin/
(
cd ~/.emacs.d
cask
)

