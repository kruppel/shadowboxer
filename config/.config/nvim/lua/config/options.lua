-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_ruby_formatter = "rubocop"

local function has_native_clipboard()
  local executable = vim.fn.executable
  local env = vim.env

  return vim.fn.has("mac") == 1
    or (env.WAYLAND_DISPLAY and executable("wl-copy") == 1 and executable("wl-paste") == 1)
    or (env.WAYLAND_DISPLAY and executable("waycopy") == 1 and executable("waypaste") == 1)
    or (env.DISPLAY and (executable("xsel") == 1 or executable("xclip") == 1))
    or executable("lemonade") == 1
    or executable("doitclient") == 1
    or executable("win32yank.exe") == 1
    or (executable("putclip") == 1 and executable("getclip") == 1)
    or (executable("clip") == 1 and executable("powershell") == 1)
    or executable("termux-clipboard-set") == 1
    or (env.TMUX and env.TMUX ~= "" and executable("tmux") == 1)
end

local is_ssh = vim.env.SSH_TTY or vim.env.SSH_CONNECTION
if is_ssh and vim.g.clipboard == nil and not has_native_clipboard() then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end

vim.opt.clipboard = "unnamedplus"
vim.opt.textwidth = 80
vim.opt.formatoptions:append("c")
