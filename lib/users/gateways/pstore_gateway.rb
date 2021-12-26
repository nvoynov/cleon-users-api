require "pstore"
require "users"

module Users
  module Gateways
  end
end

class Users::Gateways::PStoreGateway < Users::Gateways::Gateway
  def initialize
    @storage = PStore.new("service.pstore")
    transaction do
      @storage[:users] = {}
      @storage[:creds] = {}
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
    transaction { @storage[:users][user.uuid] = user }
    user
  end

  # Finds a user by :uuid
  # @param uuid [String]
  # @return [User]
  def find_user(uuid)
    super(uuid)
    user = nil
    transaction(true) { user = @storage[:users][uuid] }
    user
  end

  # Finds a user by :email
  # @param email [String]
  # @return [User]
  def find_user_by_email(email)
    user = nil
    transaction(true) do
      user = @storage[:users].values.find {|u| u.email == email}
    end
    user
  end

  # Returns collection of users
  # @param query [?]
  # @param order_by [?]
  # @param limit [Integer] number of users per data page
  # @param offset [Integer] number of page
  # @return [Array] where item 0 is [Array<User>]; and item 1 [Hash] with meta information {query:, order_by:, limit:, next:, prev:}
  def select_users(query: [], order_by: [], limit: MAX_LIMIT, offset: 0)
    limit = MAX_LIMIT if limit > MAX_LIMIT
    # TODO: apply query
    # TODO: apply order_by
    coll = nil
    meta = {query: query, order_by: order_by, limit: limit}
    transaction(true) do
      coll = @storage[:users].values[offset * limit, limit]
    end
    meta[:next] = offset + 1 if coll && coll.size == limit
    meta[:prev] = offset - 1 if offset > 0
    [coll, meta]
  end

  MAX_LIMIT = 25

  # Saves user credentials
  # @param cred [Credentials]
  # @return [Credentials]
  def save_credentials(cred)
    super(cred)
    transaction { @storage[:creds][cred.email] = cred }
    cred
  end

  # Finds user credentials
  # @param email [String]
  # @return [Credentials]
  def find_credentials(email)
    super(email)
    transaction(true) { @storage[:creds][email] }
  end

  protected

    def transaction(read_only = false)
      @storage.transaction(read_only) { yield }
    end

end
