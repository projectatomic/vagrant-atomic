module VagrantPlugins
  module GuestAtomic
    module Cap
      module Docker
        def self.docker_daemon_running(machine)
          #not sure this is the best test, seems to always pass
          machine.communicate.test("test -S /run/docker.sock")
        end
      end
    end
  end
end
