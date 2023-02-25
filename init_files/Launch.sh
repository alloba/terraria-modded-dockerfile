#!/bin/bash
#shellcheck disable=2164

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


# Installing/updating mods
mkdir -p ~/.local/share/Terraria
./manage-tModLoaderServer.sh -u --mods-only --check-dir ~/.local/share/Terraria --folder ~/.local/share/Terraria/wsmods

# Symlink tML's local dotnet install so that it can persist through runs
mkdir -p ~/.local/share/Terraria/dotnet
ln -s /home/tml/.local/share/Terraria/dotnet/ /home/tml/tModLoader/dotnet

echo "Launching tModLoader..."
cd ~/tModLoader
# Maybe eventually steamcmd will allow for an actual steamserver. For now -nosteam is required.
exec ./start-tModLoaderServer.sh -config $HOME/.local/share/Terraria/serverconfig.txt -nosteam -steamworkshopfolder $HOME/.local/share/Terraria/wsmods/steamapps/workshop
