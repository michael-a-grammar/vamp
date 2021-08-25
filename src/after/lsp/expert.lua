local expert = _G.vamp.private.expert

return {
  cmd_env = {
    MIX_DEPS_PATH = expert.use_mix_deps_path and '.expert/deps' or nil,
  },

  settings = {
    elixirSourcePath = expert.elixir_source_path,
  },
}
