require 'spec_helper'
require 'factories'

describe User do
    
    before(:each) do
        @attr = {
            :name => "Pepe",
            :surnames => "Piscinas",
            :email => "piscinas@example.com",
            :password => "abcdef",
            :username => "Pepepiscinas",
            :image => "/img/f1.png",
            :enabled => false,
            :comment => "",
            :activation_n => ""
        }
    end
    
    it "should create a new instance given valid attributes" do
        User.create!(@attr)
    end
    it "should require a name" do
        no_name_user = User.new(@attr.merge(:name => ""))
        no_name_user.should be_valid
    end
    it "should require an email address" do
        no_email_user = User.new(@attr.merge(:email => ""))
        no_email_user.should be_valid
    end
    it "should reject names that are too long" do
        long_name = "a" * 51
        long_name_user = User.new(@attr.merge(:name => long_name))
        long_name_user.should_not be_valid
    end
    it "should accept valid email addresses" do
        addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
        addresses.each do |address|
            valid_email_user = User.new(@attr.merge(:email => address))
            valid_email_user.should be_valid
        end
    end
    it "should reject invalid email addresses" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
            invalid_email_user = User.new(@attr.merge(:email => address))
            invalid_email_user.should be_valid
        end
    end
    it "should reject duplicate email addresses" do
        # Put a user with given email address into the database.
        User.create!(@attr)
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should be_valid
    end
    it "should reject email addresses identical up to case" do
        upcased_email = @attr[:email].upcase
        User.create!(@attr.merge(:email => upcased_email))
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should be_valid
    end
    
    it "should be able to ask for a new password" do
        newpass = 123456
        user = User.new(@attr)
    end
    
    describe "password validations" do
        
        it "should require a password" do
            User.new(@attr.merge(:password => "abcdef")).should be_valid
        end
        
        it "should accept short passwords" do
            short = "a" * 5
            hash = @attr.merge(:password => short)
            User.new(hash).should be_valid
        end
        
        it "should accept long passwords" do
            long = "a" * 41
            hash = @attr.merge(:password => long)
            User.new(hash).should be_valid
        end
    end
end