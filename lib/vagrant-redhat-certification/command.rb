module VagrantPlugins
  module RedHatCertification
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        'initiates Red Hat Certification process'
      end

      def execute
        @env.ui.info "Do something useful"
        #return 0 for success
        0
      end

    end # Command
  end # RedHatCertification
end # VagrantPlugins
