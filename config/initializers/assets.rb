# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( weather_forecast.css air_quality.css radar_satellis.css weather_essential.css auto_stations.css typhoon.css)
Rails.application.config.assets.precompile += %w( weather_forecast.js air_quality.js aqi_weathers.js aqi_weathers_m.js radar_satellis.js weather_essential.js auto_stations.js typhoon.js )
