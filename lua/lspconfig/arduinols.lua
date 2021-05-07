local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local root_pattern = util.root_pattern(".git")

local default_capabilities = vim.tbl_deep_extend(
  'force',
  util.default_config.capabilities or vim.lsp.protocol.make_client_capabilities(), {
  textDocument = {
    completion = {
      editsNearCursor = true
    }
  },
  offsetEncoding = {"utf-8", "utf-16"}
});

configs.arduinols = {
  default_config = {
    cmd = {"arduino-language-server", "-fqbn", "keyboardio:avr:atreus", "-cli-config", os.getenv("HOME") .. "/.arduino15/arduino-cli.yaml", "-log"};
    filetypes = {"c", "cpp"};
    root_dir = function(fname)
      local filename = util.path.is_absolute(fname) and fname
        or util.path.join(vim.loop.cwd(), fname)
      return root_pattern(filename) or util.path.dirname(filename)
    end;
    on_init = function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end;
    capabilities = default_capabilities;
  };
  docs = {
    description = [[
https://github.com/arduino/arduino-language-server

**NOTE:** Depends on 
- [arduino-cli](https://github.com/arduino/arduino-cli)
- [clangd](https://github.com/clangd/clangd)

arduino-language-server relies on an optional [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).
If no compile_commands.json file is present, the clangd process is started without the compilation database. 
]];
    default_config = {
      root_dir = [[root_pattern("compile_commands.json", ".git") or dirname]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}
-- vim:et ts=2 sw=2
