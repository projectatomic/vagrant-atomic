require "vagrant"

module VagrantPlugins
  module GuestAtomic
    class Guest < Vagrant.plugin("2", :guest)
      def detect?(machine)
        machine.communicate.test("cat /etc/os-release | grep Atomic")
      end
    end
  end
end
