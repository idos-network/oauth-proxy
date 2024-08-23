class SharedCredentialController < ApplicationController
  before_action :doorkeeper_authorize!

  def retrieve
    client = doorkeeper_token.application

    shared_credential = SharedCredentialFetcher.fetch(
      original_id: doorkeeper_token.scopes.to_s,
      grantee: doorkeeper_token.application,
    )

    render json: shared_credential
  end
end
