require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Stork::PXE" do
  before(:each) do
    @db = Stork::Database.create('./specs/tmp/file.db', collection.hosts)
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob('./specs/tmp/*'))
  end

  it "contains and can access all of the hosts" do
    collection.hosts.each do |host|
      result = @db.host(host.name)
      result[:name].must_equal host.name
      result[:action].must_equal 'localboot'
    end
  end

  it "can change the boot action and then change it back" do
    @db.boot_install('c013.example.org')
    result = @db.host('c013.example.org')
    result[:name].must_equal 'c013.example.org'
    result[:action].must_equal 'install'

    @db.boot_local('c013.example.org')
    result = @db.host('c013.example.org')
    result[:name].must_equal 'c013.example.org'
    result[:action].must_equal 'localboot'
  end
end