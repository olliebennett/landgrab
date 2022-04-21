# frozen_string_literal: true

Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with pepper (table name).
  config.salt = ENV.fetch('HASHID_SALT', '')
  # config.pepper = table_name

  # The minimum length of generated hashids
  config.min_hash_length = 6

  # The alphabet to use for generating hashids
  config.alphabet = 'abcdefghijklmnopqrstuvwxyz' \
                    '1234567890'

  # Whether to override the `find` method
  config.override_find = false

  # Whether to override the `to_param` method
  config.override_to_param = true

  # Whether to sign hashids to prevent conflicts with regular IDs (see https://github.com/jcypret/hashid-rails/issues/30)
  config.sign_hashids = false
end
