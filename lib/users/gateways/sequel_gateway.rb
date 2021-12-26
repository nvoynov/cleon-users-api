require "sequel"
require "users"

module Users
  module Gateways
  end
end

class Users::Gateways::SequelGateway < Users::Gateways::Gateway

  def initialize
    @storage = Sequel.sqlite
    @users = nil
    @creds = nil
    create_database
  end

  def create_database
    unless @users
      @storage.create_table :users do
        String :uuid, fixed: true, size: 36
        String :name, size: 50
        String :email, size: 50, unique: true, unique_constraint_name: :email_ak
        primary_key [:uuid], name: :users_pk
      end
      @users = @storage[:users]
    end

    unless @creds
      @storage.create_table :credentials do
        String :email, size: 50
        String :password_hash, size: 256
        primary_key [:email], name: :credential_pk
      end
      @creds = @storage[:credentials]
    end
  end

  # Saves a new :user
  # @param user [User]
  # @return [User]
  def save_user(user)
    super(user)
    if found = find_user_by_email(user.email)
      Users.error!("unique constraint :email") unless found.uuid == user.uuid
    end
    @users.insert(uuid: user.uuid, name: user.name, email: user.email)
    user
  end

  # Finds a user by :uuid
  # @param uuid [String]
  # @return [User]
  def find_user(uuid)
    super(uuid)
    user = @users[{uuid: uuid}]
    return nil unless user
    User.new(**user)
  end

  # Returns collection of users
  # @param query [?]
  # @param order_by [?]
  # @param limit [Integer] number of users per data page
  # @param offset [Integer] number of page
  # @return [Array] where item 0 is [Array<User>]; and item 1 [Hash] with meta information {query:, order_by:, limit:, next:, prev:}
  # @example
  #    users, meta = gateway.select_users(limit: 20)
  #    while meta[:next]
  #      items, meta = gateway.select_users(
  #        Hash[meta].merge!({offset: meta[:next]})
  #       )
  #      users.concat(items)
  #    end
  def select_users(query: [], order_by: [], limit: MAX_LIMIT, offset: 0)
    # TODO: how to pass just the same arguments? super(...) for ruby 3.0
    super(query: query, order_by: order_by, limit: limit, offset: offset)
    limit = MAX_LIMIT if limit > MAX_LIMIT
    # users query
    # users order_by
    coll = @users.limit(limit, offset * limit)
    meta = {query: query, order_by: order_by, limit: limit}
    meta[:next] = offset + 1 if coll && coll.count == limit
    meta[:prev] = offset - 1 if offset > 0
    [coll.map{|u| User.new(**u)}, meta]
  end

  MAX_LIMIT = 25

  # Finds a user by :email
  # @param email [String]
  # @return [User]
  def find_user_by_email(email)
    super(email)
    user = @users[{email: email}]
    return nil unless user
    User.new(**user)
  end

  # Saves user credentials
  # @param cred [Credentials]
  # @return [Credentials]
  def save_credentials(cred)
    super(cred)
    # TODO: insert or update!
    # DB[:table].insert_conflict(:replace).insert(a: 1, b: 2)
    # INSERT OR REPLACE INTO TABLE (a, b) VALUES (1, 2)
    @creds
      .insert_conflict(:replace)
      .insert(email: cred.email, password_hash: cred.password_hash)
    cred
  end

  # Finds user credentials
  # @param email [String]
  # @return [Credentials]
  def find_credentials(email)
    super(email)
    cred = @creds[{email: email}]
    return nil unless cred
    args = {email: email, password: "", password_hash: cred[:password_hash]}
    Credentials.new(**args)
  end

end
