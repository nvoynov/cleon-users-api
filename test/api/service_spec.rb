require_relative "../rack_helper"
# require_relative "../../lib/users/gateways/memory_gateway"
include Users::API

describe Service do
  it 'must return #base_url' do
    _(Service.base_url).must_equal "/api/v1/users"
  end

  before do
    @gateway = Users::Gateways::MemoryGateway.new
    Users.gateway = @gateway
  end

  let(:usern) { "Joe" }
  let(:email) { "joe@spec.com" }
  let(:passw) { "pa$$w0rd" }

  let(:user_params) {{"name" => usern, "email" => email, "password" => passw }}
  let(:contentjson) {{'CONTENT_TYPE' => 'application/json'}}

  def register_user(params)
    post("/api/v1/users/session/register-user",
      JSON.generate(params), contentjson)
    JSON.parse(last_response.body)
  end

  describe 'POST /users/register-user' do
    it 'must create user' do
      body = register_user(user_params)
      _(last_response.ok?).must_equal true
      _(body["data"]["uuid"]).wont_be_empty
      _(body["data"]["name"]).must_equal usern
      _(body["data"]["email"]).must_equal email
    end

    it 'must return 400 for invalid paramters' do
      body = register_user Hash[user_params].merge!({"email" => "wrong"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_match(/:email must be valid email/)

      body = register_user Hash[user_params].merge!({"password" => "short"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_match(/:password must be String\[8,50\]/)
    end
  end

  describe 'GET /api/v1/users/session/authenticate' do
    def authenticate_user(params)
      get "/api/v1/users/session/authenticate", params
      JSON.parse(last_response.body)
    end

    let(:auth_params) {
      { "email" => email, "password" => passw }
    }

    it 'must return user' do
      register_user(user_params)
      body = authenticate_user(auth_params)
      _(last_response.ok?).must_equal true
      _(body["data"]["uuid"]).wont_be_empty
      _(body["data"]["name"]).must_equal usern
      _(body["data"]["email"]).must_equal email
    end

    it 'must return 400 for invalid paramters' do
      register_user(user_params)
      # unknown email
      body = authenticate_user Hash[auth_params].merge!(
        {"email" => "wrong"})
      _(last_response.status).must_equal 400
      body = JSON.parse(last_response.body)
      _(body["error"]).must_match(/:email must be valid email/)

      # wrong password ArgumentError
      body = authenticate_user Hash[auth_params].merge!(
        {"password" => "wrong"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_match(/:password must be String\[8,50\]/)

      # wrong password
      body = authenticate_user Hash[auth_params].merge!(
        {"password" => "wrong_password"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_match(/Unknow user or password/)
    end
  end

  describe 'POST /api/v1/users/session/change-password' do

    let(:new_passw) { "new_password" }
    let(:change_params) {
      { "email" => email,
        "old_password" => passw,
        "new_password" => new_passw }
    }

    def change_password(params)
      post("/api/v1/users/session/change-password",
        JSON.generate(params), contentjson)
      JSON.parse(last_response.body)
    end

    it 'must change password' do
      register_user(user_params)
      body = change_password(change_params)
      _(last_response.ok?).must_equal true
      _(body["data"]["email"]).must_equal email
      _(body["data"]["password_hash"]).must_be_nil

      # TODO: move authenticate_user up for all tests
      # authenticate_user({"email" => email, "password" => new_passw })
      get "/api/v1/users/session/authenticate", {
        "email" => email, "password" => new_passw }
      _(last_response.ok?).must_equal true
    end

    it 'must return 400 for wrong password' do
      register_user(user_params)
      body = change_password Hash[change_params].merge!({
        "new_password" => "wrong"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_equal ":password must be String[8,50]"

      body = change_password Hash[change_params].merge!({
        "old_password" => "wrong_password"})
      _(last_response.status).must_equal 400
      _(body["error"]).must_equal "Unknow user or password"
    end
  end

  describe 'GET /api/v1/users/' do

    let(:select_params) {
      {"limit" => "25", "offset" => "0"}
    }

    before do
      # TODO: gateway.register_user!
      1.upto(10) do |index|
        Users.gateway.save_user(
          Users::Entities::User.new(
            name: "user#{index}", email: "u#{index}@spec.com")
        )
      end
    end

    def select_users(params)
      get "/api/v1/users/", params
      JSON.parse(last_response.body)
    end

    it 'must return users when params empty' do
      select_users({})
      _(last_response.ok?).must_equal true
    end

    it 'must return users collection page' do
      body = select_users(select_params)
      _(last_response.ok?).must_equal true
      _(body["links"]).wont_be_nil
      _(body["links"]["next"]).must_be_nil
      _(body["links"]["prev"]).must_be_nil
      _(body["data"]).wont_be_nil
      _(body["data"]).must_respond_to :size
      _(body["data"].size).must_equal 10
    end

    it 'must provide links' do
      body = select_users({"limit" => "3", "offset" => "0"})
      _(body["links"]["prev"]).must_be_nil
      _(body["links"]["next"]).wont_be_nil

      body = select_users({"limit" => "6", "offset" => "1"})
      _(body["links"]["prev"]).wont_be_nil
      _(body["links"]["next"]).must_be_nil

      body = select_users({"limit" => "25", "offset" => "0"})
      _(body["links"]["prev"]).must_be_nil
      _(body["links"]["next"]).must_be_nil
    end

    it 'must provide :next:link to get collection until its end' do
      users = []
      body = select_users({"limit" => "3", "offset" => "0"})
      while body["links"]["next"]
        users.concat body["data"]
        get body["links"]["next"]
        body = JSON.parse(last_response.body)
      end
      users.concat body["data"]
      _(users.size).must_equal 10
    end
  end

end
