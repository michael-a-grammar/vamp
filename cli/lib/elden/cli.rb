# frozen_string_literal: true

require          "thor"
require_relative "shell"

module Elden
  class CLI < Thor # rubocop:todo Style/Documentation
    desc "dev", "Starts a development environment"
    option :kitty_title, aliases: "k", desc: "Sets the title of the created Kitty window"
    option :sync_packer, aliases: "s", type: :boolean, desc: "Runs the PackerSync command after launch"
    def dev = elden_shell.invoke_launch_dev(kitty_title: options[:kitty_title], sync_packer: options[:sync_packer])

    private

    def elden_shell = Elden::Shell.new
  end
end
