require 'spec_helper'

describe "Plataforma Académica Universitaria" do

    it "should respond to GET" do
        get '/'
        last_response.should be_ok
        last_response.body.should match(/Inicio de sesión/)
    end

end
