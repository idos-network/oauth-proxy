class SharedCredentialFetcher
  DBID = "x44250024a9bf9599ad7c3fcdb220d2100357dbf263014485174a1ae3"

  def self.decrypt(ciphertext_base64, my_sk_base64, their_pk_base64)
    ciphertext, my_sk, their_pk =
      [ ciphertext_base64, my_sk_base64, their_pk_base64 ].map do |base64|
        Base64.decode64(base64)
      end

    RbNaCl::SimpleBox.from_keypair(
      RbNaCl::PrivateKey.new(their_pk),
      RbNaCl::PublicKey.new(my_sk),
    ).decrypt(ciphertext)
  end

  def self.fetch(original_id:, grantee:)
    shared_id = SharedCredential.find_by(original_id: original_id).duplicate_id

    response = `
      ./bin/kwil-cli database call \
        --action=get_credential_shared \
        id:#{shared_id} \
        --dbid=#{DBID} \
        --provider=https://nodes.idos.network \
        --authenticate \
          --private-key=#{grantee.sign_sk} \
          --assume-yes \
        --output=json
    `

    credential = JSON.parse(response)["result"][0]

    credential["content"] = decrypt(
      credential["content"],
      grantee.encryption_sk,
      credential["encryption_public_key"],
    )

    credential
  end
end
