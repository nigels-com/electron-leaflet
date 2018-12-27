#!/bin/bash

# Using osmium to extract GeoJSON from OSM planet
#
# https://osmcode.org/
# https://wiki.openstreetmap.org/wiki/Planet.osm

OSM=australia-latest.osm.pbf
QLD=AU-QLD.osm.pbf

### Extract the Queensland boundary

printf "Extracting boundary\n"
osmium getid -r ${OSM} r2316595 --overwrite -o AU-QLD-boundary.osm.pbf
osmium extract -p AU-QLD-boundary.osm.pbf australia-latest.osm.pbf --overwrite -o ${QLD}

### Places

for i in city town village suburb hamlet; do
  PREFIX=AU-QLD-place-${i}
  printf "Extracting %s\n" "${PREFIX}"
  osmium tags-filter --overwrite -o ${PREFIX}.osm.pbf "${QLD}" n/place=${i}
  ls -lah ${PREFIX}.osm.pbf
  osmium export --geometry-types=point -c places.json --overwrite -o tmp.geojson ${PREFIX}.osm.pbf
  ./search.py < tmp.geojson | python -m json.tool > ${PREFIX}.geojson
  ls -lah ${PREFIX}.geojson
done

### Amenities

# https://wiki.openstreetmap.org/wiki/Key:amenity
# https://wiki.openstreetmap.org/wiki/Key:leisure

for i in cafe fast_food pub restaurant bar; do
  PREFIX=AU-QLD-amenity-${i}
  printf "Extracting %s\n" "${PREFIX}"
  osmium tags-filter --overwrite -o ${PREFIX}.osm.pbf "${QLD}" n/amenity=${i}
  ls -lah ${PREFIX}.osm.pbf
  osmium export --geometry-types=point -c places.json --overwrite -o tmp.geojson ${PREFIX}.osm.pbf
  ./search.py < tmp.geojson | python -m json.tool > ${PREFIX}.geojson
  ls -lah ${PREFIX}.geojson
done

