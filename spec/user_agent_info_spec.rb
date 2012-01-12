# require 'rspec'
# require File.join(__FOLDER__, '../lib/user_agent_info')
require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

describe UserAgentInfo do

  context "OSs" do

    LINUXs = %w{Ubuntu Mandriva SUSE Debian}

    LINUXs.each do |linux_version|
      context "Linux #{linux_version}" do
        subject{ UserAgentInfo.parse("Linux #{linux_version}").os }
        its(:name){ should == 'Linux' }
        its(:version){ should == linux_version }
      end
    end
    
    context "Windows" do
      WIN_VERSIONS = {'5.1' => 'XP', 'XP' => 'XP', '6.0' => 'Vista', '6.1' => '7', 'CE' => 'CE', '95' => '95'}
      WIN_VERSIONS.each do |version,expected_version|
        context version do
          subject{ UserAgentInfo.parse("Windows NT #{version};").os }
          its(:name){ should == 'Windows' }
          its(:version){ should == expected_version }
        end
      end
      context 'NT' do
        subject{ UserAgentInfo.parse("Windows-NT").os }
        its(:name){ should == 'Windows' }
        its(:version){ should == 'NT' }
      end
    end

    context "SymbianOS" do
      context '1' do
        subject{ UserAgentInfo.parse("SymbianOS/1").os }
        its(:name){ should == 'Symbian' }
        its(:version){ should == '1' }
      end
      context '10' do
        subject{ UserAgentInfo.parse("SymbianOS/10").os }
        its(:name){ should == 'Symbian' }
        its(:version){ should == '10' }
      end
    end

    context "MacOS" do
      MAC_VERSIONS = {'10_7' => 'Lion', '10_6' => 'Snow Leopard', '10_5' => 'Leopard', '10_4' => 'Tiger'}
      MAC_VERSIONS.each do |version,expected_version|
        context version do
          subject{ UserAgentInfo.parse("Mac OS X #{version}").os }
          its(:name){ should == 'MacOS' }
          its(:version){ should == expected_version }
        end
      end
    end

    context "Android" do
      subject{ UserAgentInfo.parse("Android").os }
      its(:name){ should == 'Android' }
      its(:version){ should == 'Unknown' }
    end

  end

  context "Browsers" do

    SIMPLE = %w{Firefox Chrome Thunderbird Netscape UltraBrowser Konqueror Epiphany Iceweasel SeaMonkey Blackbird Songbird Lotus-Notes Lobo}

    SIMPLE.each do |browser|
      context browser do
        context "1" do
          subject{ UserAgentInfo.parse("#{browser}/1").agent }
          its(:name){ should == browser }
          its(:version){ should == '1' }
        end
        context "10" do
          subject{ UserAgentInfo.parse("#{browser}/10").agent }
          its(:name){ should == browser }
          its(:version){ should == '10' }
        end
      end
    end

    SPACED = {IEMobile: 'IE Mobile', MSIE: 'Internet Explorer', Android: 'Android'}

    SPACED.each do |browser, expected_browser|
      context browser do
        context "1" do
          subject{ UserAgentInfo.parse("#{browser} 1").agent }
          its(:name){ should == expected_browser }
          its(:version){ should == '1' }
        end
        context "10" do
          subject{ UserAgentInfo.parse("#{browser} 10").agent }
          its(:name){ should == expected_browser }
          its(:version){ should == '10' }
        end
      end
    end
  
    context 'MSOffice' do
      context "12" do
        subject{ UserAgentInfo.parse("MSOffice 12").agent }
        its(:name){ should == 'Outlook' }
        its(:version){ should == '2007' }
      end
    end

    context 'BrowserNG' do
      context "1" do
        subject{ UserAgentInfo.parse("BrowserNG/1").agent }
        its(:name){ should == 'Nokia Web Browser' }
        its(:version){ should == '1' }
      end
      context "10" do
        subject{ UserAgentInfo.parse("BrowserNG/10").agent }
        its(:name){ should == 'Nokia Web Browser' }
        its(:version){ should == '10' }
      end
    end

    context 'Maxthon' do
      context "/1" do
        subject{ UserAgentInfo.parse("Maxthon/1").agent }
        its(:name){ should == 'Maxthon' }
        its(:version){ should == '1' }
      end
      context "/10" do
        subject{ UserAgentInfo.parse("Maxthon/10").agent }
        its(:name){ should == 'Maxthon' }
        its(:version){ should == '10' }
      end
      context " 1" do
        subject{ UserAgentInfo.parse("Maxthon 1").agent }
        its(:name){ should == 'Maxthon' }
        its(:version){ should == '1' }
      end
      context " 10" do
        subject{ UserAgentInfo.parse("Maxthon 10").agent }
        its(:name){ should == 'Maxthon' }
        its(:version){ should == '10' }
      end
    end


    context 'Safari' do
      context "1 simple" do
        subject{ UserAgentInfo.parse("Version/1 Safari").agent }
        its(:name){ should == 'Safari' }
        its(:version){ should == '1' }
      end
      context "10 simple" do
        subject{ UserAgentInfo.parse("Version/10 Safari").agent }
        its(:name){ should == 'Safari' }
        its(:version){ should == '10' }
      end
      context "1 composed" do
        subject{ UserAgentInfo.parse("Version/1.12.12.12 Safari").agent }
        its(:name){ should == 'Safari' }
        its(:version){ should == '1' }
      end
      context "10 composed" do
        subject{ UserAgentInfo.parse("Version/10.1.10.100 Safari").agent }
        its(:name){ should == 'Safari' }
        its(:version){ should == '10' }
      end
    end

    context 'Opera' do
      context "1 simple" do
        subject{ UserAgentInfo.parse("Opera/1").agent }
        its(:name){ should == 'Opera' }
        its(:version){ should == '1' }
      end
      context "10 simple" do
        subject{ UserAgentInfo.parse("Opera/10").agent }
        its(:name){ should == 'Opera' }
        its(:version){ should == '10' }
      end
      context "10 composed" do
        subject{ UserAgentInfo.parse("Opera/6 Version/10").agent }
        its(:name){ should == 'Opera' }
        its(:version){ should == '10' }
      end
    end

    context 'rekonq' do
      subject{ UserAgentInfo.parse("rekonq").agent }
      its(:name){ should == 'rekonq' }
      its(:version){ should == 'Unknown' }
    end

    context 'Blackberry' do
      context '1' do
        let(:parse1){ UserAgentInfo.parse("BlackBerry1/2") }
        describe 'agent' do
          subject{ parse1.agent }
          its(:name){ should == 'BlackBerry' }
          its(:version){ should == '1' }
        end
        describe 'os' do
          subject{ parse1.os }
          its(:name){ should == 'RIM OS' }
          its(:version){ should == '2' }
        end
      end
      context '10' do
        let(:parse10){ UserAgentInfo.parse("BlackBerry10/20") }
        describe 'agent' do
          subject{ parse10.agent }
          its(:name){ should == 'BlackBerry' }
          its(:version){ should == '10' }
        end
        describe 'os' do
          subject{ parse10.os }
          its(:name){ should == 'RIM OS' }
          its(:version){ should == '20' }
        end
      end
    end
  
    context 'iPhone Safari' do
      context '1' do
        let(:parse1){ UserAgentInfo.parse("iPhone OS 2 Version/1") }
        describe 'agent' do
          subject{ parse1.agent }
          its(:name){ should == 'Safari' }
          its(:version){ should == '1' }
        end
        describe 'os' do
          subject{ parse1.os }
          its(:name){ should == 'iPhone' }
          its(:version){ should == '2' }
        end
      end
      context '10' do
        let(:parse10){ UserAgentInfo.parse("iPhone OS 20 Version/10") }
        describe 'agent' do
          subject{ parse10.agent }
          its(:name){ should == 'Safari' }
          its(:version){ should == '10' }
        end
        describe 'os' do
          subject{ parse10.os }
          its(:name){ should == 'iPhone' }
          its(:version){ should == '20' }
        end
      end
    end
  
  end
  
end