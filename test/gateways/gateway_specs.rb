require "users"
include Users::Entities

module SharedSaveUser
  extend Minitest::Spec::DSL

  it 'must save user' do
    user = User.new(name: "user", email: "m@u.c" )
    result = gateway.save_user(user)
    assert_instance_of User, result
    refute_nil result.uuid
    refute_empty result.uuid
    assert_equal user.name, result.name
    assert_equal user.email, result.email
    assert gateway.find_user(user.uuid)
    # FIXME: another test added ten users ... maybe gateway.clear need there?
    # coll, meta = gateway.select_users
    # assert_equal 1, coll.size
  end

  # TODO: how it must deal with non-unique emails? It checks by service,
  #       but should be cotrolled by the gateway also
  let(:user) { User.new(name: "user", email: "m@u.c") }
  let(:another) { User.new(name: "another", email: "m@u.c") }
  it 'must check :email_ak' do
    gateway.save_user(user)
    err = assert_raises(Users::Error) { gateway.save_user(another) }
    assert_match %r{unique constraint :email}, err.message
  end

end

module SharedFindUser
  extend Minitest::Spec::DSL

  let(:user) { User.new(name: "user", email: "m@u.c") }

  it 'must return user by :uuid' do
    gateway.save_user(user)
    found = gateway.find_user(user.uuid)
    refute_nil found
    assert_instance_of User, found
    assert_equal found.uuid, user.uuid
  end

  it 'must return nil when user was not found' do
    gateway.save_user(user)
    found = gateway.find_user("unknown uuid")
    refute found
  end
end

module SharedFindUserByEmail
  extend Minitest::Spec::DSL

  let(:user) { User.new(name: "user", email: "m@u.c") }
  it 'must return user by :email' do
    gateway.save_user(user)
    found = gateway.find_user_by_email(user.email)
    assert found
    assert_instance_of User, found
    assert_equal user.email, found.email
  end

  it 'must return nil when email was not found' do
    refute gateway.find_user_by_email("unknown")
  end
end

module SharedSelectUsers
  extend Minitest::Spec::DSL

  # SETUP = begin
  before do
    1.upto(10) do |index|
      gateway.save_user(
        User.new(name: "user#{index}", email: "m#{index}@u.c")
      )
    end
  end

  it 'must return collection and metadata' do
    coll, meta = gateway.select_users()
    assert_instance_of Array, coll
    assert_instance_of Hash, meta
    assert_instance_of User, coll.first
  end

  it 'must return collection by :limit and :offset' do
    coll, meta = gateway.select_users(limit: 3)
    assert_equal 3, coll.size
    refute_nil meta[:next]
    assert_nil meta[:prev]

    coll, meta = gateway.select_users(limit: 3, offset: 1)
    assert_equal 3, coll.size
    refute_nil meta[:next]
    refute_nil meta[:prev]

    coll, meta = gateway.select_users(limit: 3, offset: 3)
    assert_equal 1, coll.size
    assert_nil meta[:next]
    refute_nil meta[:prev]
  end

  it 'must traverse all the collection by :next' do
    users, meta = gateway.select_users(limit: 3)
    while meta[:next]
      coll, meta = gateway.select_users(limit: 3, offset: meta[:next])
      users.concat(coll)
    end
    assert_equal 10, users.size
  end

  it 'must return collection according to :filter'
  it 'must return collection according to :order_by'
end

module SharedSaveCredentials
  extend Minitest::Spec::DSL

  let(:cred) { Credentials.new(email: "m@u.c", password: 'pa$$w0rd') }
  it 'must save credentials' do
    crd = gateway.save_credentials(cred)
    assert_instance_of Credentials, crd
    assert gateway.find_credentials(crd.email)
  end

end

module SharedFindCredentials
  extend Minitest::Spec::DSL

  let(:cred) { Credentials.new(email: "m@u.c", password: 'pa$$w0rd') }
  it 'must find credenital by email' do
    gateway.save_credentials(cred)
    found = gateway.find_credentials(cred.email)
    assert found
    assert_instance_of Credentials, found
    assert_equal found.email, cred.email
  end

  it 'must return nil when does not found' do
    refute gateway.find_credentials("unknown@u.c")
  end
end
