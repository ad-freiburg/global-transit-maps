OCTI=/home/patrick/repos/loom/build/octi
LOOM=/home/patrick/repos/loom/build/loom
TOPO=/home/patrick/repos/loom/build/topo
TRANSITMAP=/home/patrick/repos/loom/build/transitmap

.PRECIOUS: %.20.topo.json %.19.topo.json %.18.topo.json %.17.topo.json %.16.topo.json %.15.topo.json  %.14.topo.json %.13.topo.json tram-subway.json


%.json: queries/%.sparql
	@# get qid
	curl -s -G --data-urlencode "backend=https://qlever.cs.uni-freiburg.de/api/osm-germany"   --data-urlencode "query@$<" "https://qlever.cs.uni-freiburg.de/mapui-petri/query" > response.json
	@# download GeoJSON export
	curl -s -G --data "id=`jq .qid response.json | tr -d '\"'`" "https://qlever.cs.uni-freiburg.de/mapui-petri/export" > $@
	# rm response.json

%.17.topo.json: %.json
	$(TOPO) -d 25 < $< > $@

%.16.topo.json: %.json
	$(TOPO) -d 50 < $< > $@

%.15.topo.json: %.json
	$(TOPO) -d 100 < $< > $@

%.14.topo.json: %.json
	$(TOPO) -d 200 < $< > $@

%.13.topo.json: %.json
	$(TOPO) -d 400 < $< > $@

%.loom.json: %.topo.json
	$(LOOM) -m greedy-lookahead < $< > $@

%.geo.json: %.loom.json
	cp $< $@

%.octi.json: %.loom.json
	$(OCTI) < $< > $@

tiles/%: tiles/%/17 tiles/%/16 tiles/%/15 tiles/%/14 tiles/%/13 tiles/%/12 tiles/%/11;

.SECONDEXPANSION:
tiles/%/geo/20: %.17.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/19: %.17.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/18: %.17.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/17: %.17.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/16: %.16.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/15: %.15.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=3 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/14: %.14.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=3 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/13: %.13.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=2 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/12: %.13.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/geo/11: %.13.geo.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=1 --line-spacing=0 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

##########

.SECONDEXPANSION:
tiles/%/octi/20: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<


.SECONDEXPANSION:
tiles/%/octi/19: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<


.SECONDEXPANSION:
tiles/%/octi/18: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/18: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/17: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/16: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/15: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/14: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=5 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/13: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/12: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=2 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

.SECONDEXPANSION:
tiles/%/octi/11: %.14.octi.json
	mkdir -p $@
	$(TRANSITMAP) --render-engine mvt --line-width=4 --line-spacing=1 -z=$(lastword $(subst /, , $@)) --mvt-path tiles/$* < $<

clean:
	rm *.json
