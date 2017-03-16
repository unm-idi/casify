# module Casify
  class Casify::User

    attr_reader :username, :email, :roles

    def initialize(hsh)
      if hsh.kind_of? Hash
        @username = hsh['username']
        @email = hsh['extra_attributes']['email']
        @roles = set_roles(hsh)
      end
    end

    def has_role?(role, resource)
      @roles.find do |a_role|
        a_role['role'] == role.to_s && a_role['resource'] == resource
      end.present?
    end

    def resources_by_roles(role)
      @roles.map do |a_role|
        a_role['resource'] if a_role['role'] == role.to_s
      end.compact
    end

    def roles_by_resource(resource)
      @roles.map do |a_role|
        a_role['role'] if a_role['resource'] == resource.to_s
      end.compact
    end

    private

    def set_roles(hsh)
      Marshal.load(Marshal.dump(hsh['roles'])).freeze
    end

  end
# end
