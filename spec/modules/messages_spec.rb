require 'spec_helper'

describe "Messages" do

    before(:each) do
        @user = FactoryGirl.create(:user)
        @attr = { :content => "value for content" }
    end
    
    it "should create a new instance given valid attributes" do
        @user.messages.create!(@attr)
    end
    
    describe "user associations" do
        
        before(:each) do
            @message = @user.messages.create(@attr)
        end
        
        it "should have a user attribute" do
            @message.should respond_to(:user)
        end
        
        it "should have the right associated user" do
            @message.user_id.should == @user.id
            @message.user.should == @user
        end
    end
    
    
    describe "validations" do
        
        it "should require a user id" do
            Messages.new(@attr).should_not be_valid
        end
        
        it "should require nonblank content" do
            @user.messages.build(:content => "  ").should_not be_valid
        end

    end
end