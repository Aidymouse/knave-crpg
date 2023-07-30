return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "isometric",
  renderorder = "right-down",
  width = 2,
  height = 2,
  tilewidth = 256,
  tileheight = 128,
  nextlayerid = 3,
  nextobjectid = 1,
  properties = {
    ["z_level"] = 1
  },
  tilesets = {
    {
      name = "CRPG Tiles",
      firstgid = 1,
      filename = "tiled/CRPG Tiles.tsx",
      exportfilename = "tilesets/CRPG Tiles.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 2,
      height = 2,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 0
      },
      encoding = "lua",
      data = {
        3, 3, 
        3, 3, 

      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 2,
      height = 2,
      id = 2,
      name = "Tile Layer 2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 1
      },
      encoding = "lua",
      data = {
        0, 0,
        0, 0,

      }
    }
  }
}
