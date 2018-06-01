OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           #TODO: Guardar aquestes variables en un env var o alguna cosa similar
           '913002110494-9v1l42d9s83567i24j1gqu3dqkhl41b2.apps.googleusercontent.com',
           'y3jUhAZdFUbvw_Mee88Rnqr3',
           {
             client_options: {
               ssl: {
                   ca_file: Rails.root.join("cacert.pem").to_s
               }
            },
            skip_jwt: true
           }
end
