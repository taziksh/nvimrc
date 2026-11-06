local function eval_range(start_line, end_line)
  vim.fn.MoltenEvaluateRange(start_line, end_line)
end

local function find_markdown_code_cell()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local start_line

  for line = cursor, 1, -1 do
    if vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]:match("^%s*```") then
      start_line = line
      break
    end
  end

  if not start_line then
    return nil
  end

  for line = start_line + 1, vim.api.nvim_buf_line_count(0) do
    if vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]:match("^%s*```%s*$") then
      if cursor <= line then
        return start_line + 1, line - 1
      end
      return nil
    end
  end

  return nil
end

local function find_percent_cell()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local start_line = 1
  local end_line = vim.api.nvim_buf_line_count(0)

  for line = cursor, 1, -1 do
    if vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]:match("^%s*#%s*%%%%") then
      start_line = line + 1
      break
    end
  end

  for line = cursor + 1, end_line do
    if vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]:match("^%s*#%s*%%%%") then
      end_line = line - 1
      break
    end
  end

  return start_line, end_line
end

local function evaluate_current_cell()
  local filetype = vim.bo.filetype
  local start_line, end_line

  if filetype == "markdown" then
    start_line, end_line = find_markdown_code_cell()
  elseif filetype == "python" then
    start_line, end_line = find_percent_cell()
  end

  if not start_line or not end_line or start_line > end_line then
    vim.notify("No runnable Molten cell found under cursor", vim.log.levels.WARN)
    return
  end

  eval_range(start_line, end_line)
end

return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = function()
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
      })
    end,
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    lazy = false,
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/bin/python")
      vim.g.molten_auto_init_behavior = "init"
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_win_max_height = 18
      vim.g.molten_wrap_output = true
      vim.g.molten_image_provider = "none"
      vim.g.molten_virt_text_output = false
    end,
    config = function()
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*.ipynb",
        callback = function()
          vim.schedule(function()
            local ok, status = pcall(require, "molten.status")
            if ok and status.initialized() ~= "Molten" then
              pcall(vim.cmd, "MoltenInit python3")
            end
          end)
        end,
      })
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit python3<cr>", desc = "Molten init python3" },
      { "<leader>m?", "<cmd>MoltenInit<cr>", desc = "Molten choose kernel" },
      { "<leader>mI", "<cmd>MoltenInfo<cr>", desc = "Molten info" },
      { "<leader>mc", evaluate_current_cell, desc = "Molten run current cell" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten run line" },
      { "<leader>mv", ":<c-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Molten run selection" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten rerun cell" },
      { "<leader>mn", "<cmd>MoltenNext<cr>", desc = "Molten next cell" },
      { "<leader>mp", "<cmd>MoltenPrev<cr>", desc = "Molten previous cell" },
      { "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Molten enter output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Molten hide output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten delete cell" },
      { "<leader>mD", "<cmd>MoltenDelete!<cr>", desc = "Molten delete all cells" },
      { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten restart kernel" },
      { "<leader>mx", "<cmd>MoltenOpenInBrowser<cr>", desc = "Molten open HTML output" },
    },
  },
}
