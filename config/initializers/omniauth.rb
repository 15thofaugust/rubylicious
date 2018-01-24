OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    "186374245187-knne0ss5581rhbq4uki63eud941jcmvd.apps.googleusercontent.com",
    "ZtrPsU0R96cnPdNw6c6AtzCD",
    {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
