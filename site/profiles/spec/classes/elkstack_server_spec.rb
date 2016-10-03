require 'spec_helper'

describe 'consul_server' do
  context 'RHEL 7 Logging Server' do
    before(:each) do
      Puppet.features.stubs(:microsoft_windows? => false, :posix? => true)
    end
    let(:pre_condition) {
      """
      Package {
        provider => 'yum',
      }

      User {
        provider => 'useradd',
      }

      """
    }
    let(:facts) { {
      :clientcert => 'elkstack.gcio.cloud',
      :pce_environment => 'local',
      :boks_active => false,
      :rpm => '/bin/rpm',
      :server_role => 'consul_server',
      :osfamily => 'RedHat',
      :kernel => 'linux',
      :architecture => 'x86_64',
      :operatingsystem => 'RedHat',
      } }
      it { should compile.with_all_deps }
      it { should contain_class('elkstack_server') }

    end
  end
