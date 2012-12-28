require 'spec_helper'

Pau.define :user do |user|
    user.name                  "Pedro Lopez"
    user.email                 "plopez@example.com"
    user.password              "plopez"
    user.password_confirmation "plopez"
end

Pau.sequence :name do |n|
    "Person #{n}"
end

Pau.sequence :email do |n|
    "person-#{n}@example.com"
end

Pau.define :message do |msg|
    msg.content "Something"
    msg.association :user
end

describe "Plataforma Academica Universitaria" do

    before(:each) do
        user = Messages(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
    end

    
    it "should respond to GET" do
        get '/'
        last_response.should be_ok
        last_response.body.should match(/Inicio de sesión/)
    end

    
end
