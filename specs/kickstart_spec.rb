require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Kickstart" do
  before(:each) do
    @host = collection.hosts.get("server.example.org")
  end

  %w{ RHEL5 RHEL6 RHEL7 }.each do |ver|
    it "should generate valid kickstart configurations for #{ver}" do
      # skip("pending")

      ksvalidate = File.join(File.dirname(__FILE__), 'scripts', 'ksvalidate.sh')
      testpath = File.join(File.dirname(__FILE__), 'tmp')
      kspath = File.join(File.dirname(__FILE__), 'tmp', 'output.ks')

      template = File.dirname(__FILE__) + "/files/configs/templates/default.ks.erb"
      ks = Midwife::Kickstart.new(@host, configuration)

      file = File.open('specs/tmp/output.ks', 'w')
      file.write(ks.render)
      file.close

      Open3.popen3("#{ksvalidate} #{testpath} #{kspath} #{ver}") do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value.to_i
        output = (stdout.readlines + stderr.readlines).join
        assert_equal(0, exit_status, output)
      end

      File.unlink('specs/tmp/output.ks')
    end
  end
end
