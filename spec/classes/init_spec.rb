require 'spec_helper'

describe 'prometheus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe "Create the config file" do
        context "with the defaults, using the tempate" do
          it do
            should contain_file("prometheus.yaml")
              .with(content: /---/)
          end
        end
        context "when parameter config_type is source and and config_source is supplied" do
          let(:thesource) { File.expand_path(File.dirname(__FILE__) + '/../fixtures/files/prometheus.yaml') }
          let(:params) {{ :config_type   => 'source', :config_source => thesource }}
          it do
            should contain_file("prometheus.yaml")
              .with(source: thesource)
          end
        end
        context "with an invalid config_type" do
          let(:params) {{ :config_type   => 'invalid' }}
          it do
            expect {
              catalogue
            }.to raise_error(Puppet::Error, /is not supported by this module/)
          end
        end
      end
    end
  end
end
