build:
	coffee -o ./ -m -c app/assets/javascripts/seapig/seapig-router.js.coffee
	mv seapig-router.js.js seapig-router.js
	mv seapig-router.js.js.map seapig-router.js.map
	sed -i -e s/.js.js/.js/ seapig-router.js.map
	uglifyjs seapig-router.js --in-source-map seapig-router.js.map -cm --source-map seapig-router.min.js.map >seapig-router.min.js

clean:
	rm seapig-router.js  seapig-router.js.map  seapig-router.min.js  seapig-router.min.js.map

test:
	node_modules/jasmine-node/bin/jasmine-node --coffee --verbose spec