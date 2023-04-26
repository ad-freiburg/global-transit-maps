OCTI=/local/data/brosip/loom/build/octi --write-stats
LOOM=/local/data/brosip/loom/build/loom --write-stats
TOPO=/local/data/brosip/loom/build/topo --write-stats --random-colors --turn-restr-full-turn-pen 500
TRANSITMAP=/local/data/brosip/loom/build/transitmap --print-stats

TRAMSTATS_GEO = $(patsubst %,stats/tram/%/geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
TRAMSTATS_OCTI = $(patsubst %,stats/tram/%/octi.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
TRAMSTATS_OCTIGEO = $(patsubst %,stats/tram/%/octi-geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
TRAMSTATS_ORTHORAD = $(patsubst %,stats/tram/%/orthorad.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)

SUBWAY_LIGHTRAILSTATS_GEO = $(patsubst %,stats/subway-lightrail/%/geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
SUBWAY_LIGHTRAILSTATS_OCTI = $(patsubst %,stats/subway-lightrail/%/octi.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
SUBWAY_LIGHTRAILSTATS_OCTIGEO = $(patsubst %,stats/subway-lightrail/%/octi-geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
SUBWAY_LIGHTRAILSTATS_ORTHORAD = $(patsubst %,stats/subway-lightrail/%/orthorad.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)

RAIL_COMMUTERSTATS_GEO = $(patsubst %,stats/rail-commuter/%/geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAIL_COMMUTERSTATS_OCTI = $(patsubst %,stats/rail-commuter/%/octi.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAIL_COMMUTERSTATS_OCTIGEO = $(patsubst %,stats/rail-commuter/%/octi-geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAIL_COMMUTERSTATS_ORTHORAD = $(patsubst %,stats/rail-commuter/%/orthorad.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)

RAILSTATS_GEO = $(patsubst %,stats/rail/%/geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAILSTATS_OCTI = $(patsubst %,stats/rail/%/octi.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAILSTATS_OCTIGEO = $(patsubst %,stats/rail/%/octi-geo.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
RAILSTATS_ORTHORAD = $(patsubst %,stats/rail/%/orthorad.stats.json, 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)

tram: $(TRAMSTATS_GEO) $(TRAMSTATS_OCTI) $(TRAMSTATS_OCTIGEO) $(TRAMSTATS_ORTHORAD)
subway: $(SUBWAY_LIGHTRAILSTATS_GEO) $(SUBWAY_LIGHTRAILSTATS_OCTI) $(SUBWAY_LIGHTRAILSTATS_OCTIGEO) $(SUBWAY_LIGHTRAILSTATS_ORTHORAD)
rail-commuter: $(RAIL_COMMUTERSTATS_GEO) $(RAIL_COMMUTERSTATS_OCTI) $(RAIL_COMMUTERSTATS_OCTIGEO) $(RAIL_COMMUTERSTATS_ORTHORAD)
rail: $(RAILSTATS_GEO) $(RAILSTATS_OCTI) $(RAILSTATS_OCTIGEO) $(RAILSTATS_ORTHORAD)


# keep all intermediate files
.SECONDARY:

%.json: queries/%.sparql
	@# get qid
	curl -s -G --data-urlencode "backend=https://qlever.cs.uni-freiburg.de/api/osm-planet"   --data-urlencode "query@$<" "https://qlever.cs.uni-freiburg.de/mapui-petri/query" > response.json
	@# download GeoJSON export
	curl -s -G --data "id=`jq .qid response.json | tr -d '\"'`" "https://qlever.cs.uni-freiburg.de/mapui-petri/export" > $@
	rm response.json

# TOPO
# ============

rail.15.topo.json: rail.json
	mkdir -p components/rail/15
	$(TOPO) --write-components --write-components-path components/rail/15 -d 400 --infer-restr-max-dist 400 < $< > $@

rail.%.topo.json: rail.15.topo.json
	ln -s $< $@
	ln -s 15 components/rail/$*

rail-commuter.15.topo.json: rail-commuter.json
	mkdir -p components/rail-commuter/15
	$(TOPO) --write-components --write-components-path components/rail-commuter/15 -d 400 --infer-restr-max-dist 400 < $< > $@

rail-commuter.%.topo.json: rail-commuter.15.topo.json
	ln -s $< $@
	ln -s 15 components/rail-commuter/$*

%.20.topo.json: %.15.topo.json
	ln -s $< $@
	ln -s 15 components/$*/20

%.19.topo.json: %.15.topo.json
	ln -s $< $@
	ln -s 15 components/$*/19

%.18.topo.json: %.15.topo.json
	ln -s $< $@
	ln -s 15 components/$*/18

%.17.topo.json: %.15.topo.json
	ln -s $< $@
	ln -s 15 components/$*/17

%.16.topo.json: %.15.topo.json
	ln -s $< $@
	ln -s 15 components/$*/16

%.15.topo.json: %.json
	mkdir -p components/$*/15
	$(TOPO) --write-components --write-components-path components/$*/15 -d 100 < $< > $@

%.14.topo.json: %.15.topo.json
	mkdir -p components/$*/14
	$(TOPO)  --write-components --write-components-path components/$*/14 -d 200 < $< > $@

.SECONDEXPANSION:
%.topo.json: $$(firstword $$(subst ., , $$*)).14.topo.json | dummy%
	ln -s $< $@
	ln -s 14 components/$(firstword $(subst ., , $*))/$(lastword $(subst ., , $*))

# requried to make to catch-all rules above less attractive, see
# https://stackoverflow.com/questions/18716736/changing-the-priority-of-rules-in-make/18726681#18726681
dummy%:
	@:

#########


%.20.loom.json: %.15.loom.json
	ln -s $< $@

%.19.loom.json: %.15.loom.json
	ln -s $< $@

%.18.loom.json: %.15.loom.json
	ln -s $< $@

%.17.loom.json: %.15.loom.json
	ln -s $< $@

%.16.loom.json: %.15.loom.json
	ln -s $< $@

%.15.loom.json: %.15.topo.json
	$(LOOM) -m anneal < $< > $@

%.14.loom.json: %.14.topo.json
	$(LOOM) -m anneal < $< > $@

.SECONDEXPANSION:
%.loom.json: $$(firstword $$(subst ., , $$*)).14.loom.json | dummy%
	ln -s $< $@

#########

%.geo.json: %.loom.json
	ln -s $< $@


%.15.octi.json: %.15.topo.json
	$(OCTI) --retry-on-error --skip-on-error -g 75% < $< > $@

%.15.octi-geo.json: %.15.topo.json
	$(OCTI) --retry-on-error --skip-on-error --nd-move-pen 5 --geo-pen 10 --skip-on-error -g 50% < $< > $@

%.15.orthorad.json: %.15.topo.json
	$(OCTI) --retry-on-error --skip-on-error -b orthoradial -g 75% < $< > $@


.SECONDEXPANSION:
%.octi.json: $$(firstword $$(subst ., , $$*)).15.octi.json | dummy%
	ln -s $< $@

.SECONDEXPANSION:
%.octi-geo.json: $$(firstword $$(subst ., , $$*)).15.octi-geo.json | dummy%
	ln -s $< $@

.SECONDEXPANSION:
%.orthorad.json: $$(firstword $$(subst ., , $$*)).15.orthorad.json | dummy%
	ln -s $< $@

%.15.octi.loom.json: %.15.octi.json
	$(LOOM) -m anneal < $< > $@

%.15.octi-geo.loom.json: %.15.octi-geo.json
	$(LOOM) -m anneal < $< > $@

%.15.orthorad.loom.json: %.15.orthorad.json
	$(LOOM) -m anneal < $< > $@

.SECONDEXPANSION:
%.octi.loom.json: $$(firstword $$(subst ., , $$*)).15.octi.loom.json | dummy%
	ln -s $< $@

.SECONDEXPANSION:
%.octi-geo.loom.json: $$(firstword $$(subst ., , $$*)).15.octi-geo.loom.json | dummy%
	ln -s $< $@

.SECONDEXPANSION:
%.orthorad.loom.json: $$(firstword $$(subst ., , $$*)).15.orthorad.loom.json | dummy%
	ln -s $< $@

.SECONDEXPANSION:
tiles/%/geo/20: %.20.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/19: %.19.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/18: %.15.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/17: %.15.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/16: %.15.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/15: %.15.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/14: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=3 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/13: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=3 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/12: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=2 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/11: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/10: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/9: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/8: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/7: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/6: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/5: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/4: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/3: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/2: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/1: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/geo/0: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/geo < $< > $@/stats.json
##########

.SECONDEXPANSION:
tiles/%/octi/20: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/octi/19: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/octi/18: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/17: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/16: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/15: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=4 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/14: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/13: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/12: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/11: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=2 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/10: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/9: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/8: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/7: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/6: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/5: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/4: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/3: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/2: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/1: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi/0: %.14.octi.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi < $< > $@/stats.json
##########

.SECONDEXPANSION:
tiles/%/octi-geo/20: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/octi-geo/19: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/octi-geo/18: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/17: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/16: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/15: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=4 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/14: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/13: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/12: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/11: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=2 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/10: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/9: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/8: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/7: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/6: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/5: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/4: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/3: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/2: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/1: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/octi-geo/0: %.14.octi-geo.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/octi-geo < $< > $@/stats.json

##########

.SECONDEXPANSION:
tiles/%/orthorad/20: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/orthorad/19: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json


.SECONDEXPANSION:
tiles/%/orthorad/18: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/17: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/16: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/15: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=4 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/14: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=4 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/13: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/12: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=3 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/11: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=2 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/10: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/9: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/8: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/7: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/6: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/5: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/4: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/3: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/2: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/1: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json

.SECONDEXPANSION:
tiles/%/orthorad/0: %.14.orthorad.loom.json
	mkdir -p $@
	$(TRANSITMAP) --tight-stations --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$*/orthorad < $< > $@/stats.json


# STATS
# -------------------------------
.SECONDEXPANSION:
stats/%/octi.stats.json: $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).topo.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).octi.loom.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).octi.json tiles/$$(firstword $$(subst /, , $$*))/octi/$$(lastword $$(subst /, , $$*))
	mkdir -p stats/$*
	jq '{"topo": .[0].properties.statistics, "loom": .[1].properties.statistics, "octi": .[2].properties.statistics, "render":.[3]}' -s $^/stats.json > $@

.SECONDEXPANSION:
stats/%/octi-geo.stats.json: $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).topo.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).octi-geo.loom.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).octi-geo.json tiles/$$(firstword $$(subst /, , $$*))/octi-geo/$$(lastword $$(subst /, , $$*))
	mkdir -p stats/$*
	jq '{"topo": .[0].properties.statistics, "loom": .[1].properties.statistics, "octi": .[2].properties.statistics, "render":.[3]}' -s $^/stats.json > $@

.SECONDEXPANSION:
stats/%/orthorad.stats.json: $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).topo.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).orthorad.loom.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).orthorad.json tiles/$$(firstword $$(subst /, , $$*))/orthorad/$$(lastword $$(subst /, , $$*))
	mkdir -p stats/$*
	jq '{"topo": .[0].properties.statistics, "loom": .[1].properties.statistics, "octi": .[2].properties.statistics, "render":.[3]}' -s $^/stats.json > $@

.SECONDEXPANSION:
stats/%/geo.stats.json: $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).topo.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).loom.json $$(firstword $$(subst /, , $$*)).$$(lastword $$(subst /, , $$*)).geo.json tiles/$$(firstword $$(subst /, , $$*))/geo/$$(lastword $$(subst /, , $$*))
	mkdir -p stats/$*
	jq '{"topo": .[0].properties.statistics, "loom": .[1].properties.statistics, "octi": {}, "render":.[3]}' -s $^/stats.json > $@

clean:
	rm *.json
