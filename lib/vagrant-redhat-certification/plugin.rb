begin
  require 'vagrant'
rescue LoadError
  raise 'The vagrant-atomic plugin must be run within Vagrant.'
end

module VagrantPlugins
  module RedHatCertification
    class Plugin < Vagrant.plugin("2")
      name "Red Hat Certification"
      description <<-DESC
      This plugin makes Red Hat Certification easier.
      DESC

      command "redhat-certification" do
        require_relative 'command'
        Command
      end
    end
  end
end