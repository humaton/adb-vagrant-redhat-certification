module VagrantPlugins
  module RedHatCertification
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        'initiates Red Hat Certification process'
      end

      def execute
        @env.ui.info "Do something useful"
        options = {}

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant redhat-certification [docker image tag] [vm-name]"
          o.separator ""
          o.separator "Options:"
          o.separator ""
        end
        argv = parse_options(opts)

        with_target_vms(nil, single_target: true) do |machine|
          if machine.guest.name == :redhat
            if machine.guest.capability?(:rhcert)
              run_cert_tool machine argv[0]
            else
              @env.ui.info "Your machine does not have tool necessary to continue certification process."
              install_deps = @env.ui.ask("Would you like to install missing tools (default: yes)? [y|n] ")
              unless install_deps == 'n'
                if install_cert_tool machine
		  prepare_cert_tool machine
		  run_cert_tool machine argv[0]
                end
              end
            end
          else
            @env.ui.info "Red Hat certification is supported only on Red Hat Enterprise Linux distributions"
            return 1
          end
        end
      end

      private
      def install_cert_tool machine
	machine.communicate.execute('yum install -y redhat-certification', :sudo => true)
      end
      
      def prepare_cert_tool machine
	machine.communicate.execute('setenforce 0', :sudo => true)
	machine.communicate.execute('rhcert-backend server start', :sudo => true)
	machine.communicate.execute('rhcert-backend server stop', :sudo => true)
	#do some stuff
	
	#start cert daemon again
	machine.communicate.execute('rhcert-backend server start', :sudo => true)
      end
      
      def run_cert_tool machine, container_id, cert_id = nil, manifest = nil, server =nil
	machine.communicate.execute('docker export #{container_id} > export.tar', :sudo => true)
        machine.communicate.execute('setenforce 0', :sudo => true)
        machine.communicate.execute('rhcert-backend save --id #{cert_id} --image export.tar --manifest  #{manifest} --server #{server} #{container_id}', :sudo => true)
        machine.communicate.execute('setenforce 1', :sudo => true)
      end
    end # Command
  end # RedHatCertification
end # VagrantPlugins
