local original_paste = vim.paste

local function get_dropped_path(lines)
  if #lines ~= 1 then
    return nil
  end

  local path = vim.trim(lines[1])
  path = path:gsub("^['\"](.*)['\"]$", "%1")

  if path:match "^file://" then
    path = path:gsub("^file://", "")
    path = path:gsub("%%(%x%x)", function(hex)
      return string.char(tonumber(hex, 16))
    end)
  end

  if path:sub(1, 1) ~= "/" then
    path = vim.fn.fnamemodify(path, ":p")
  end

  if vim.fn.filereadable(path) == 1 then
    return path
  end

  return nil
end

vim.paste = function(lines, phase)
  -- Handle single-event Kitty drops.
  if phase ~= -1 then
    return original_paste(lines, phase)
  end

  local path = get_dropped_path(lines)

  if not path then
    -- Ordinary text paste stays unchanged.
    if vim.bo.filetype == "NvimTree" then
      vim.notify("Drop a local file into NvimTree.", vim.log.levels.WARN)
      return true
    end

    return original_paste(lines, phase)
  end

  if vim.bo.filetype ~= "NvimTree" then
    vim.notify("Dropped file: " .. path)
    return true
  end

  -- Dropped on NvimTree: copy into the selected directory.
  local api = require "nvim-tree.api"
  local node = api.tree.get_node_under_cursor()

  if not node then
    vim.notify "Select a destination folder in NvimTree."
    return true
  end

  local destination_dir = node.absolute_path

  if node.type ~= "directory" then
    destination_dir = vim.fs.dirname(destination_dir)
  end

  local destination = vim.fs.joinpath(destination_dir, vim.fs.basename(path))

  if vim.uv.fs_stat(destination) then
    vim.notify("File already exists: " .. destination, vim.log.levels.WARN)
    return true
  end

  local ok, err = vim.uv.fs_copyfile(path, destination)

  if not ok then
    vim.notify("Copy failed: " .. tostring(err), vim.log.levels.ERROR)
    return true
  end

  api.tree.reload()
  return true
end
