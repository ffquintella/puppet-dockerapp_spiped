require 'spec_helper'

describe 'dockerapp_spiped' do
  let(:title) { 'spiped_var' }
  let(:params) do
    {
      version: '1.2',
      key: 'test123',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('dockerapp') }
      it { is_expected.to contain_class('docker') }
      it { is_expected.to contain_file('/srv/application-data/spiped_var') }
      it { is_expected.to contain_file('/srv/application-config/spiped_var') }
      it { is_expected.to contain_file('/srv/application-lib/spiped_var') }
      it { is_expected.to contain_file('/srv/application-log/spiped_var') }
      it { is_expected.to contain_file('/srv/scripts/spiped_var') }
      it {
        is_expected.to contain_dockerapp__run('spiped_var')
          .with(
            image: 'spiped:1.2',
          )
      }
    end
  end
end
