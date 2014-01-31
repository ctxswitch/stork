require File.dirname(__FILE__) + '/spec_helper'

describe Midwife::Config do
  before :each do
    @partitions = %w{default split}
    @domains = %w{private test local}
    @templates = %w{default other}
    @hosts = %w{ 
      system1.local
      system2.local
      system3.local
      system4.local
      system5.local
      system6.local
      system7.local
      system8.local
      system9.local
      system10.local
      other1.private
    }
  end

  it "read and evaluate the config files" do
    config = Midwife::Config.build('specs/files/configs')
    config.partitions.keys.sort.must_equal @partitions.sort
    config.domains.keys.sort.must_equal @domains.sort
    config.templates.keys.sort.must_equal @templates.sort
    config.hosts.keys.sort.must_equal @hosts.sort
  end

  it "should expose itself to midwife environment" do
    config = Midwife::Config.build('specs/files/configs')
    Midwife.partitions.keys.sort.must_equal @partitions.sort
    Midwife.domains.keys.sort.must_equal @domains.sort
    Midwife.templates.keys.sort.must_equal @templates.sort
    Midwife.hosts.keys.sort.must_equal @hosts.sort
  end
end