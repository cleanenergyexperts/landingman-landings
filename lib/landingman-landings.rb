require "middleman-core"

Middleman::Extensions.register :landingman_landings do
  require "landingman-landings/extension"
  ::Landingman::LandingsExtension
end
