# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile = [ /\A[^\/\\]+\.(ccs|js)$/i ]
# Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

Rails.application.config.assets.precompile += %w(organization_admin/organization_admin.css campaign_admin/campaign_admin.css end_user/end_user.css)
Rails.application.config.assets.precompile += %w(organization_admin/organization_admin.js campaign_admin/campaign_admin.js end_user/end_user.js)
