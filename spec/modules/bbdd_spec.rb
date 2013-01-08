RSpec.configure do |config|
    config.include Rack::Test::Methods
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bbdd.db")
    DataMapper.finalize
    Post.auto_migrate!
    Tag.auto_migrate!
end

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
           change(Tagm :count).by(2)
       }
    end
end
