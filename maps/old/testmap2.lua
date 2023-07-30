return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.1",
  class = "",
  orientation = "isometric",
  renderorder = "right-down",
  width = 8,
  height = 8,
  tilewidth = 256,
  tileheight = 128,
  nextlayerid = 8,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "CRPG Tiles",
      firstgid = 1,
      filename = "tiled/CRPG Tiles.tsx",
      exportfilename = "tilesets/CRPG Tiles.lua"
    },
    {
      name = "CRPG Tiles 2",
      firstgid = 5,
      filename = "tiled/CRPG Tiles 2.tsx",
      exportfilename = "tilesets/CRPG Tiles 2.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 1,
      name = "z0",
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
        2, 2, 2, 2, 2, 4, 3, 5,
        2, 2, 2, 2, 2, 4, 3, 5,
        2, 2, 2, 2, 2, 4, 3, 5,
        2, 2, 2, 2, 2, 4, 3, 5,
        2, 2, 2, 2, 2, 4, 3, 5,
        4, 4, 4, 4, 4, 4, 3, 5,
        3, 3, 3, 3, 3, 3, 3, 5,
        5, 5, 5, 5, 5, 5, 5, 5
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 4,
      name = "z1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -128,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 1
      },
      encoding = "lua",
      data = {
        2, 2, 2, 2, 2, 0, 0, 0,
        2, 2, 2, 2, 2, 0, 0, 0,
        2, 2, 2, 2, 2, 0, 0, 0,
        2, 2, 2, 2, 2, 0, 0, 0,
        2, 2, 2, 2, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 5,
      name = "z2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -256,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 2
      },
      encoding = "lua",
      data = {
        2, 2, 2, 2, 0, 0, 0, 0,
        2, 2, 2, 2, 0, 0, 0, 0,
        2, 2, 2, 2, 0, 0, 0, 0,
        2, 2, 2, 2, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 6,
      name = "z3",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -384,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 3
      },
      encoding = "lua",
      data = {
        2, 2, 2, 0, 0, 0, 0, 0,
        2, 2, 2, 0, 0, 0, 0, 0,
        2, 2, 2, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 7,
      name = "z4",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -512,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 4
      },
      encoding = "lua",
      data = {
        3, 3, 0, 0, 0, 0, 0, 0,
        3, 3, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
