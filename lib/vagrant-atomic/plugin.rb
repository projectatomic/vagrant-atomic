begin
  require 'vagrant'
rescue LoadError
  raise 'The vagrant-atomic plugin must be run within Vagrant.'
end

module VagrantPlugins
  module GuestAtomic
    class Plugin < Vagrant.plugin("2")
      name "Atomic Host guest"
      description "Atomic Host guest support."

      guest("atomic", "redhat") do
        require File.expand_path("../guest", __FILE__)
        Guest
      end

      guest_capability("atomic", "change_host_name") do
        require_relative "cap/change_host_name"
        Cap::ChangeHostName
      end

      guest_capability("atomic", "configure_networks") do
        require_relative "cap/configure_networks"
        Cap::ConfigureNetworks
      end

      guest_capability("atomic", "docker_daemon_running") do
        require_relative "cap/docker"
        Cap::Docker
      end

      # This sets up our log level to be whatever VAGRANT_LOG is
      # for loggers prepended with 'vagrant_libvirt'
      def self.setup_logging
        require 'log4r'
        level = nil
        begin
          level = Log4r.const_get(ENV['VAGRANT_LOG'].upcase)
        rescue NameError
          # This means that the logging constant wasn't found,
          # which is fine. We just keep `level` as `nil`. But
          # we tell the user.
          level = nil
        end
        # Some constants, such as "true" resolve to booleans, so the
        # above error checking doesn't catch it. This will check to make
        # sure that the log level is an integer, as Log4r requires.
        level = nil if !level.is_a?(Integer)
        # Set the logging level on all "vagrant" namespaced
        # logs as long as we have a valid level.
        if level
          logger = Log4r::Logger.new('vagrant_atomic')
          logger.outputters = Log4r::Outputter.stderr
          logger.level = level
          logger = nil
        end
      end

#shouldn't need these as I inherit
      # guest_capability("atomic", "register") do
      #   require_relative "cap/register"
      #   Cap::Register
      # end
  
      # guest_capability("atomic", "unregister") do
      #   require_relative "cap/unregister"
      #   Cap::Unregister
      # end


    end
  end
end
