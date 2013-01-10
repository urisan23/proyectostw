require 'spec_helper'
require 'factory_girl'

FactoryGirl.define do
    factory :user do 
        name               "Pedro Lopez"
        email              "plopez@example.com"
        password           "plopez"
    end

    factory :message do
        content       "Something"
        association   :user
    end
end
    
#FactoryGirl.sequence :name do |n|
#   "Person #{n}"
#end

#FactoryGirl.sequence :email do |n|
#    "person-#{n}@example.com"
#end

#FactoryGirl.define :message do |msg|
#    msg.content "Something"
#    msg.association :user
#end