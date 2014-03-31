layout "home" do
  clearpart
  zerombr
  part "/boot" do
    size 100
    type "ext4"
    primary
  end

  part "swap" do
    size 0
    type "swap"
    primary
  end

  part "/" do
    size 4096
    type "ext4"
  end

  part "pv.01" do
    size 1
    grow
  end

  volume_group "vg", part: "pv.01" do
    logical_volume "lv_home" do
      path "/home"
      size 1
      grow
    end
  end
end
