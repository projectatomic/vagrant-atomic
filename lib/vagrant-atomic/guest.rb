require "vagrant"

module VagrantPlugins
  module GuestAtomic
    class Guest < Vagrant.plugin("2", :guest)
      def detect?(machine)
	# For now we use this non 100% bullet proof solution.
	# Bugs issued to include word atomic in upstream releases
	# Centos: http://bugs.centos.org/view.php?id=8288
	# Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=1200122
	#
	# machine.communicate.test("cat /etc/os-release | grep Atomic")
        machine.communicate.test("which rpm-ostree")
      end
    end
  end
end
