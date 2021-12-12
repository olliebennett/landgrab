required_envs = [
  {
    env: 'WHAT3WORDS_API_KEY',
    desc: 'What3Words.com API Key',
    src: 'https://developer.what3words.com/public-api'
  }
]

required_envs.each do |req_env|
  next if ENV.fetch(req_env[:env], nil).present?

  raise "ENV var missing: '#{req_env[:env]}' (#{req_env[:desc]}) - see #{req_env[:src]}"
end
