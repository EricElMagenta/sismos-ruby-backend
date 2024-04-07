class EarthquakeController < ApplicationController
  def new
    # response = HTTParty.get("https://api.publicapis.org/categories")
    # @response = JSON.parse(response.body)
    # @categories = @response["categories"]

    # Obtiene los datos a la página solicitada con un GET request
    response = HTTParty.get("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson")

    # Convierte los datos recibidos en un objecto JSON
    @response = JSON.parse(response.body)

    # Guarda los datos de los sismos
    @features = @response["features"]

    # Filtra los datos según los atributos especificados
    @properties = @features.map { |feature| feature["properties"]
    .slice("mag", 
          "place",
          "time",
          "url",
          "tsunami",
          "type",
          "magType",
          "title")
    }

    # Guarda la longitud y la latitud de cada sismo en una nueva propiedad "coordinates"
    @features.each_with_index do |feature, index|
      @properties[index]["id"] = index
      @properties[index]["coordinates"] = feature["geometry"]["coordinates"].slice(0, 2)
    end 

    console

  end
end


# INFORMACIÓN RECIBIDA
# `id`, 
# `properties.mag`, 
# `properties.place`, 
# `properties.time`, 
# `properties.url`, 
# `properties.tsunami`,
#  `properties.magType`, 
#  `properties.title`, 
#  `geometry.coordinates[0]` (longitude) y 
#  `geometry.coordinates[1]` (latitude).

# FORMATO REQUERIDO
# {
# "data": [
# {
# "id": Integer,
# "type": "feature",
# "attributes": {
# "external_id": String,
# "magnitude": Decimal,
# "place": String,
# "time": String,
# "tsunami": Boolean,
# "mag_type": String,
# "title": String,
# "coordinates": {
# "longitude": Decimal,
# "latitude": Decimal
# }
# },
# "links": {
# "external_url": String
# }
# }
# ],
# "pagination": {
# "current_page": Integer,
# "total": Integer,
# "per_page": Integer
# }
# }

# La data debe poder ser filtrada por:
# `mag_type`. Using filters[mag_type]. Puede ser más de uno. Valores posibles: md, ml, ms, mw, me, mi, mb, mlg.
# `page`
# `per_page`. Validar per_page <= 1000