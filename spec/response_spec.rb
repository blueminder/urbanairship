describe Urbanairship::Response do

  before do
    FakeWeb.allow_net_connect = false
  end

  context "::code" do
    subject { Urbanairship.register_device("new_device_token") } 

    before do
      FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/new_device_token", :status => ["201", "Created"])
      FakeWeb.register_uri(:put, /bad_key\:my_app_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])
      Urbanairship.application_secret = "my_app_secret"
    end

    it "should be set correctly on new registraion token" do
      Urbanairship.application_key = "my_app_key"
      subject.code.should eql '201'
    end

    it "should set correctly on unauthhorized" do
      Urbanairship.application_key = "bad_key"
      subject.code.should eql '401'
    end
 end

  context "::success?" do
    subject { Urbanairship.register_device("new_device_token") } 

    before do
      FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/new_device_token", :status => ["201", "Created"])
      FakeWeb.register_uri(:put, /bad_key\:my_app_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])
      Urbanairship.application_secret = "my_app_secret"
    end

    it "should be true with good key" do
      Urbanairship.application_key = "my_app_key"
      subject.success?.should == true
    end

    it "should be false with bad key" do
      Urbanairship.application_key = "bad_key"
      subject.success?.should == false
    end
  end

  context "::body" do
    before do
      FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["200", "OK"], :body => "[{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}]")
      Urbanairship.application_secret = "my_app_secret"
      Urbanairship.application_key = "my_app_key"
      Urbanairship.master_secret = "my_master_secret"
    end

    subject { Urbanairship.feedback(Time.now) } 
    
    it "should be set" do
      subject.body.should eql "[{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}]"
    end
  end

  context "::request_timeout?" do
    it "should report a timeout" do
      # TODO : Test this... 
    end
  end
end
