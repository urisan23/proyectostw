require 'spec_helper'

describe "Bbdd" do

    describe "post /new" do
        it "should insert the post and its tags in the database" do
            lambda do
                post "/new", params = {
                    :title => 'title',
                    :body => 'body',
                    :tags => 'hello, world',
                }
            end.should{
                change(Post, :count).by(1)
                change(Tag, :count).by(2)
            }
        end
    end
end