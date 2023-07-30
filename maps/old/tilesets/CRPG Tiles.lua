return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.1",
  name = "CRPG Tiles",
  class = "",
  tilewidth = 256,
  tileheight = 256,
  spacing = 0,
  margin = 0,
  columns = 0,
  objectalignment = "unspecified",
  tilerendersize = "tile",
  fillmode = "stretch",
  tileoffset = {
    x = 0,
    y = 0
  },
  grid = {
    orientation = "orthogonal",
    width = 1,
    height = 1
  },
  properties = {},
  wangsets = {},
  tilecount = 3,
  tiles = {
    {
      id = 1,
      properties = {
        ["traversable"] = true
      },
      image = "../../graphics/tile.png",
      width = 256,
      height = 256
    },
    {
      id = 2,
      properties = {
        ["traversable"] = true
      },
      image = "../../graphics/grass.png",
      width = 256,
      height = 256
    },
    {
      id = 3,
      properties = {
        ["traversable"] = true,
        ["y_offset"] = -10
      },
      image = "../../graphics/stone.png",
      width = 256,
      height = 256
    }
  }
}
