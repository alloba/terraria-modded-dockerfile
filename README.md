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

**Docker Commands** 

docker build -t terraria-box .
docker run -d \
 -p 7777:7777 \
 -v {LOCAL_PATH}/Terraria_Data:/home/tml/.local/share/Terraria/ \
 --name terraria-box-instance \
 terraria-box


docker stop terraria-box-instance 
docker rm terraria-box-instance 
