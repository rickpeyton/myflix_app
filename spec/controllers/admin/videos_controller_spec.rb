require 'spec_helper'

describe Admin::VideosController do
  describe "GET #new" do
    it "sets a new video instance" do
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
    end
  end
end
