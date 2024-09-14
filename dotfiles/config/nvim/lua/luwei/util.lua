local M = {}

M.old_eslint_config_files = {
  ".eslintrc.js",
  ".eslintrc.ts",
  ".eslintrc.mjs",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc",
}

M.new_eslint_config_files = {
  "eslint.config.js",
  "eslint.config.ts",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.json",
  "eslint.config.yaml",
  "eslint.config.yml",
}

-- 递归向上查找是否存在指定文件，如果存在返回文件所在目录，否则返回nil
M.get_root_path_recurse_by_file = function(filename, start_dir)
  start_dir = start_dir or vim.fn.getcwd() -- 默认为当前工作目录
  local current_dir = start_dir

  while true do
    local file_path = vim.fn.fnamemodify(current_dir, ":p") .. "/" .. filename
    if vim.fn.filereadable(file_path) == 1 then
      return current_dir
    end

    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
    if parent_dir == current_dir then
      return nil
    end

    current_dir = parent_dir
    if current_dir == "/" then
      return nil
    end
  end
end

M.get_root_path_by_files = function(filenames)
  for _, file in ipairs(filenames) do
    local root_path = M.get_root_path_recurse_by_file(file)
    if root_path ~= nil then
      return root_path
    end
  end
  return nil
end

M.get_eslint_root_path = function()
  return M.get_root_path_by_files(M.new_eslint_config_files) or M.get_root_path_by_files(M.old_eslint_config_files)
end

-- 根剧文件名从当前目录、向上目录查找配置文件
M.get_config_file = function(config_files)
  for _, file in ipairs(config_files) do
    local root_path = M.get_root_path_recurse_by_file(file)
    if root_path ~= nil then
      return root_path .. "/" .. file
    end
  end
  return nil
end

M.get_new_eslint_config = function()
  return M.get_config_file(M.new_eslint_config_files)
end

M.get_old_eslint_config = function()
  return M.get_config_file(M.old_eslint_config_files)
end

M.has_old_eslint_config = function()
  return M.get_old_eslint_config() ~= nil
end

M.has_new_eslint_config = function()
  return M.get_new_eslint_config() ~= nil
end

-- 从当前文件所在目录开始递归向上查找是否存在eslint配置文件，如果存在返回文件所在目录，否则返回nil
M.has_eslint_config = function()
  return M.has_old_eslint_config() or M.has_new_eslint_config()
end

M.get_eslint_config = function()
  return M.get_new_eslint_config() or M.get_old_eslint_config()
end

return M
