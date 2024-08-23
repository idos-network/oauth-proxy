Doorkeeper.configure do
  resource_owner_authenticator do
    OpenStruct.new(id: 0)
  end

  # default_scopes :read
  # optional_scopes :write

  after_successful_authorization do |controller, context|
    next unless controller.class == Doorkeeper::AuthorizationsController

    controller.request.params => {
      scope: original_id,
      duplicate_credential_id: duplicate_id,
      client_id: application_id,
    }

    SharedCredential.create(original_id:, duplicate_id:, application_id:)
  end
end

# FIXME: monkey patching isn't good for one's health

module Doorkeeper

  # Forces doorkeeper to accept any scope, since we're using it for the
  # resource ID
  #
  # * Is there a standard way to pass extra parameters in an authorization request?
  #   would be more elegant than overloading the scope parameter

  module OAuth
    class PreAuthorization
      def validate_scopes
        true
      end
    end
  end

  module Models
    module Scopes
      def includes_scope?(*required_scopes)
        true
      end
    end
  end

  # These should probably be helpers in the rails world iirc
  class Application
    def encryption_pk_base64
      return unless encryption_sk.present?

      Base64.strict_encode64(
        RbNaCl::PrivateKey.new(
          Base64.decode64(encryption_sk),
        ).public_key,
      )
    end

    def sign_pk_hex
      return unless sign_sk.present?

      Eth::Key.new(priv: sign_sk).address
    end
  end
end
