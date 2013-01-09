FactoryGirl.define :user do |user|
    user.name                  "Pedro Lopez"
    user.email                 "plopez@example.com"
    user.password              "plopez"
    user.password_confirmation "plopez"
end

FactoryGirl.sequence :name do |n|
    "Person #{n}"
end

FactoryGirl.sequence :email do |n|
    "person-#{n}@example.com"
end

FactoryGirl.define :message do |msg|
    msg.content "Something"
    msg.association :user
end