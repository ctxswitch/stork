require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Deploy::Kickstart" do
  before(:each) do
    load_config
    @host = collection.hosts.get("server.example.org")
    @path = File.dirname(__FILE__)
    FileUtils.mkdir_p "#{@path}/tmp"
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{@path}/tmp/*"))
  end

  %w{ RHEL5 RHEL6 RHEL7 }.each do |ver|
    it "should generate valid kickstart configurations for #{ver}" do
      ksvalidate  = "#{@path}/scripts/ksvalidate.sh"
      testpath    = "#{@path}"
      kspath      = "#{@path}/tmp/output.ks"
      #template    = "#{@path}/stork/bundles/templates/default.ks.erb"

      ks = Stork::Deploy::InstallScript.new(@host, :kickstart)

      File.open("#{@path}/tmp/output.ks", 'w') do |file|
        file.write(ks.render)
      end

      Open3.popen3("#{ksvalidate} #{testpath} #{kspath} #{ver}") do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value.to_i
        output = (stdout.readlines + stderr.readlines).join
        assert_equal(0, exit_status, output)
      end

      File.unlink("#{@path}/tmp/output.ks")
    end
  end
end
