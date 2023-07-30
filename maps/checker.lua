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
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "test_tiles",
      firstgid = 1,
      filename = "tiled/test_tiles.tsx",
      exportfilename = "tilesets/test_tiles.lua"
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
        3, 4, 3, 4, 3, 4, 3, 4,
        4, 3, 4, 3, 4, 3, 4, 3,
        3, 4, 3, 4, 3, 4, 3, 4,
        4, 3, 4, 3, 4, 3, 4, 3,
        3, 4, 3, 4, 3, 4, 3, 4,
        4, 3, 4, 3, 4, 3, 4, 3,
        3, 4, 3, 4, 3, 4, 3, 4,
        4, 3, 4, 3, 4, 3, 4, 3
      }
    }
  }
}
