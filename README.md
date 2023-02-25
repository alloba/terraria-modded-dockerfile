# OnlyFriends Terraria Server 

## Mods List 

[
  "WMITF",
  "WingSlotExtra",
  "SubworldLibrary",
  "RecipeBrowser",
  "OreExcavator",
  "MrPlagueRaces",
  "MagicStorage",
  "DisableCorruptionSpread",
  "CalamityModMusic",
  "CalamityMod",
  "BossCursor",
  "BossChecklist",
  "ArmorReforge",
  "ThoriumMod",
  "AlchemistNPCLite"
]

## Running 

Everything is wrapped up in a dockerfile, so you should just have to run that. 
Default files are provided in the init_files directory. 
Changes to configuration options should be done by editing files mounted in a shared directory. 

**Please do change the default password I beg you**

**Docker Commands** 

docker build -t terraria-box .
docker run -d \
 -p 7777:7777 \
 -v {LOCAL_MOUNT_DIRECTORY}/Terraria_Data:/home/tml/.local/share/Terraria/ \
 --name terraria-box-instance \
 terraria-box


docker stop terraria-box-instance 
docker rm terraria-box-instance 

## DATA 

The server's data is kept in the container's `/home/tml/.local/share/Terraria/` directory. 
This includes world saves, downloaded mods, and runtime environment. 

This is the same folder that you should mount to an external volume. 

The easiest way to back things up would be to grab the entire mounted folder, 
but if space is a concern it is enough to just grab the worlds folder. 
Meaning the `{LOCAL_MOUNT_DIRECTORY}/Worlds` folder. 
