#!/bin/bash
pipe=/tmp/tmod.pipe
alias inject="$HOME/inject"

# First time setup of config files (edit mounted files for future changes)
if [ ! -f ~/.local/share/Terraria/install.txt ] 
then 
 cp ~/install.txt ~/.local/share/Terraria 
fi

if [ ! -f ~/.local/share/Terraria/enabled.json ] 
then 
 cp ~/enabled.json ~/.local/share/Terraria
fi

if [ ! -f ~/.local/share/Terraria/serverconfig.txt ] 
then 
 cp ~/serverconfig.txt ~/.local/share/Terraria
fi


# Trapped Shutdown, to cleanly shutdown
function shutdown () {
  tmuxPid=$(pgrep tmux)
  tmodPid=$(pgrep -P $tmuxPid)
  #inject "say SHUTTING DOWN"
  tmux send-keys -t 0 "say SHUTTING DOWN" Enter
  sleep 3s
  #inject "exit"
  tmux send-keys -t 0 "exit" Enter 
  while [ -e /proc/$tmodPid ]; do
    sleep .5
  done
  rm $pipe
}

# Installing/updating mods
mkdir -p ~/.local/share/Terraria
./manage-tModLoaderServer.sh -u --mods-only --check-dir ~/.local/share/Terraria --folder ~/.local/share/Terraria/wsmods

# Symlink tML's local dotnet install so that it can persist through runs
mkdir -p ~/.local/share/Terraria/dotnet
ln -s /home/tml/.local/share/Terraria/dotnet/ /home/tml/tModLoader/dotnet

echo "Launching tModLoader..."
cd ~/tModLoader



trap shutdown TERM INT
mkfifo $pipe 
#tmux new-session -d "./start-tModLoaderServer.sh -config $HOME/.local/share/Terraria/serverconfig.txt -nosteam -steamworkshopfolder $HOME/.local/share/Terraria/wsmods/steamapps/workshop | tee $pipe"
tmux new-session -d "./LaunchUtils/ScriptCaller.sh -server -config $HOME/.local/share/Terraria/serverconfig.txt -nosteam -steamworkshopfolder $HOME/.local/share/Terraria/wsmods/steamapps/workshop | tee $pipe"

cat $pipe &
wait ${!}
