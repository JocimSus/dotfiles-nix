--
-- neotest
--

local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-java")({
      runner = "gradle",
    }),
  },
})

local map = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

map("<leader>tt", function()
  neotest.run.run()
end, "Test: Run nearest")

map("<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, "Test: Run file")

map("<leader>ta", function()
  neotest.run.run({ suite = true })
end, "Test: Run all")

map("<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, "Test: Debug nearest")

map("<leader>tq", function()
  neotest.run.stop()
end, "Test: Stop")

map("<leader>ts", function()
  neotest.summary.toggle()
end, "Test: Toggle summary")

map("<leader>to", function()
  neotest.output.open({ enter = true })
end, "Test: Show output")

map("<leader>tO", function()
  neotest.output_panel.toggle()
end, "Test: Toggle output panel")
