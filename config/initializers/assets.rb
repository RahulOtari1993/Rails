# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
#
# Rails.application.config.assets.precompile += %w(libraries/bootstrap.min.css)
# Rails.application.config.assets.precompile += %w(libraries/material-design-iconic-font.min.css)
# Rails.application.config.assets.precompile += %w(super_admin/super_admin.css)
Rails.application.config.assets.precompile += %w(organization_admin/organization_admin.css)
Rails.application.config.assets.precompile += %w(libraries/plugins/extensions/toastr.css)
#
# Rails.application.config.assets.precompile += %w(super_admin/super_admin.js)
Rails.application.config.assets.precompile += %w(organization_admin/organization_admin.js)
Rails.application.config.assets.precompile += %w(vendors/extensions/toastr.min.js)



# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.Rails.application.config.assets.precompile += %w( organization_admin/organization_admin.js )
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
