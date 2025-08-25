
Rails.application.configure do
  # Set up image variants for different sizes
  config.active_storage.previewers << ActiveStorage::Previewer::PopplerPDFPreviewer
  config.active_storage.previewers << ActiveStorage::Previewer::MuPDFPreviewer
  config.active_storage.previewers << ActiveStorage::Previewer::VideoPreviewer
end

# Configure image processing
if Rails.env.development?
  # Allow all hosts in development
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end