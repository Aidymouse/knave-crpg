<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.1" name="CRPG Tiles" tilewidth="256" tileheight="256" tilecount="3" columns="0">
 <editorsettings>
  <export target="../tilesets/CRPG Tiles.lua" format="lua"/>
 </editorsettings>
 <grid orientation="orthogonal" width="1" height="1"/>
 <tile id="1">
  <properties>
   <property name="traversable" type="bool" value="true"/>
  </properties>
  <image width="256" height="256" source="../../graphics/tile.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="traversable" type="bool" value="true"/>
  </properties>
  <image width="256" height="256" source="../../graphics/grass.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="traversable" type="bool" value="true"/>
   <property name="y_offset" type="int" value="-10"/>
  </properties>
  <image width="256" height="256" source="../../graphics/stone.png"/>
 </tile>
</tileset>
