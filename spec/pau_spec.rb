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


describe "LayoutLinks" do
    
    it "should have a Home page at '/'" do
        get '/'
        response.should have_selector('title', :content => "Inicio")
    end
    
    it "should have a Logout page at '/logout'" do
        get '/contact'
        response.should have_selector('title', :content => "Cerrar sesión")
    end
    
    it "should have an Subjects page at '/subjects'" do
        get '/about'
        response.should have_selector('title', :content => "Asignaturas")
    end
    
    it "should have a Help page at '/help'" do
        get '/help'
        response.should have_selector('title', :content => "Ayuda")
    end
    
    it "should have a Contact page at '/contact'" do
        get '/help'
        response.should have_selector('title', :content => "Contacta con nosotros")
    end

    
    it "should have a Signup page at '/signup'" do
        get '/signup'
        response.should have_selector('title', :content => "Regístrate ahora")
    end

    it "should have a Forgotten Password page at '/forgotten_pass'" do
        get '/signup'
        response.should have_selector('title', :content => "¿Olvidó su contraseña?")
    end
    
    it "should have a Change Password page at '/change_pass'" do
        get '/signup'
        response.should have_selector('title', :content => "Cambiar contraseña")
    end
    
    it "should have a Edit Profile page at '/edit_profile'" do
        get '/signup'
        response.should have_selector('title', :content => "Editar perfil")
    end
    
    it "should have a Admin page at '/admin'" do
        get '/signup'
        response.should have_selector('title', :content => "Administración")
    end
    
    describe "when not signed in" do
        it "should have a signin link" do
            visit root_path
            response.should have_selector("a", :href => signin_path,
                                          :content => "Entrar")
        end
    end
    
    describe "when signed in" do
        
        before(:each) do
            @user = Messages(:user)
            visit signin_path
            fill_in :email,    :with => @user.email
            fill_in :password, :with => @user.password
            click_button
        end
        
        it "should have a signout link" do
            visit root_path
            response.should have_selector("a", :href => signout_path,
                                          :content => "Salir")
        end
        
        it "should have a profile link" do
            visit root_path
            response.should have_selector("a", :href => user_path(@user),
                                          :content => "Perfil")
        end
    end
end


describe "Users" do
    
    describe "signup" do
        
        describe "failure" do
            
            it "should not make a new user" do
                lambda do
                    visit signup_path
                    fill_in "Nombre",             :with => ""
                    fill_in "Email",              :with => ""
                    fill_in "Password",           :with => ""
                    fill_in "Confirmar password", :with => ""
                    click_button
                    response.should render_template('users/new')
                    response.should have_selector("div#error_explanation")
                end.should_not change(User, :count)
            end
        end
        describe "success" do
            
            it "should make a new user" do
                lambda do
                    visit signup_path
                    fill_in "Nombre",             :with => "Pedro Lopez"
                    fill_in "Email",              :with => "plopez@example.com"
                    fill_in "Password",           :with => "plopez"
                    fill_in "Confirmar password", :with => "plopez"
                    fill_in :user_notification,   :with => "0"
                    click_button
                    response.should have_selector("div.flash.success",
                                                  :content => "Bienvenido")
                    response.should render_template('users/show')
                end.should change(User, :count).by(1)
            end
        end
    end
    
    describe "sign in/out" do
        
        describe "failure" do
            it "should not sign a user in" do
                visit signin_path
                fill_in :email,    :with => ""
                fill_in :password, :with => ""
                click_button
                response.should have_selector("div.flash.error", :content => "Combinacion")
            end
        end
        
        describe "success" do
            it "should sign a user in and out" do
                user = Messages(:user)
                visit signin_path
                fill_in :email,    :with => user.email
                fill_in :password, :with => user.password
                click_button
                controller.should be_signed_in
                click_link "Salir"
                controller.should_not be_signed_in
            end
        end
    end
end