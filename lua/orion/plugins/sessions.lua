local bind = require("keybinder")

return {
  "rmagatti/auto-session",
  config = function()
    local overseer = require("overseer")
    local auto_session = require("auto-session")

    -- Convert the cwd to a simple file name
    local function get_cwd_as_name()
      local dir = vim.fn.getcwd(0)
      return dir:gsub("[^A-Za-z0-9]", "_")
    end

    auto_session.setup({
      auto_session_enable_last_session = vim.loop.cwd()
        == vim.loop.os_homedir(),

      -- Support for overseer
      pre_save_cmds = {
        function()
          overseer.save_task_bundle(
            get_cwd_as_name(),
            -- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
            -- pass in the results if you want to save specific tasks.
            nil,
            { on_conflict = "overwrite" } -- Overwrite existing bundle, if any
          )
        end,
      },
    })
  end,
}
