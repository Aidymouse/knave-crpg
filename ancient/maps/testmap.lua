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
  nextlayerid = 7,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "test_tiles",
      firstgid = 1,
      filename = "tiled/test_tiles.tsx",
      exportfilename = "tilesets/test_tiles.lua"
    },
    {
      name = "fence",
      firstgid = 8,
      filename = "tiled/fence.tsx",
      exportfilename = "fence.lua"
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
        3, 3, 3, 3, 1, 1, 1, 1,
        3, 3, 3, 3, 1, 1, 1, 1,
        3, 3, 3, 3, 1, 1, 1, 1,
        3, 3, 3, 3, 1, 1, 1, 1,
        3, 4, 3, 3, 3, 1, 4, 1,
        3, 4, 4, 3, 3, 4, 4, 4,
        3, 4, 4, 4, 4, 4, 4, 4,
        3, 3, 3, 4, 4, 4, 4, 4
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 2,
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
        1, 1, 5, 0, 0, 0, 0, 0,
        1, 1, 5, 0, 0, 8, 12, 12,
        2, 1, 5, 0, 0, 10, 0, 0,
        2, 7, 6, 0, 0, 0, 15, 0,
        3, 0, 0, 0, 0, 0, 0, 10,
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 3,
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
        2, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        4, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 4,
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
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 5,
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
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 6,
      name = "z5",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -640,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["z_level"] = 5
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
