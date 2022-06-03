local lualine = require("lualine")
local gps = require("nvim-gps")

gps.setup()

lualine.setup({
   options = {
      theme = "gruvbox-material",
      component_separators = "|",
      section_separators = "",
      globalstatus = true,
   },
   sections = {
      lualine_b = {
         { "branch", icon = "" },
      },
      lualine_c = {
         { gps.get_location, cond = gps.is_available },
      },
   },
})
