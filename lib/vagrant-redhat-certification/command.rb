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
          o.banner = "Usage: vagrant redhat-certification [options]"
          o.separator ""
          o.separator "Options:"
          o.separator ""
        end
        argv = parse_options(opts)
        puts "#{argv}"
        #return 0 for success
        0
      end

      private

      def cert_tool? guest

      end
    end # Command
  end # RedHatCertification
end # VagrantPlugins
