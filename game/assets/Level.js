(function (window) {

    var p = Level.prototype = new createjs.Container();

    p.stage;

    var tileset;
    var mapData;

    function Level(stage) {
        this.initialize();
        this.stage = stage;
    }

    // constructor:
    p.Container_initialize = p.initialize;  //unique to avoid overiding base class

    p.initialize = function (sprite) {
        this.Container_initialize();

         $.ajax({
            url: 'assets/Level1.json',
            async: false,
            dataType: 'json',
            success: function (response) {
                mapData = response;
                
                // create EaselJS image for tileset
                tileset = new Image();
                // getting imagefile from first tileset
                tileset.src = mapData.tilesets[0].image;
                // callback for loading layers after tileset is loaded
                tileset.onLoad = initLayers();
            }
        }); 
    }

    function initLayers() {
		// compose EaselJS tileset from image (fixed 64x64 now, but can be parametized)
		var w = mapData.tilesets[0].tilewidth;
		var h = mapData.tilesets[0].tileheight;
		var imageData = {
			images : [ tileset ],
			frames : {
				width : w,
				height : h
			}
		};
		// create spritesheet
		var tilesetSheet = new createjs.SpriteSheet(imageData);
		
		// loading each layer at a time
		for (var idx = 0; idx < mapData.layers.length; idx++) {
			var layerData = mapData.layers[idx];
			if (layerData.type == 'tilelayer')
				initLayer(layerData, tilesetSheet, mapData.tilewidth, mapData.tileheight);
		}
	}

	// layer initialization
	function initLayer(layerData, tilesetSheet, tilewidth, tileheight) {
		for ( var y = 0; y < layerData.height; y++) {
			for ( var x = 0; x < layerData.width; x++) {
				// create a new Bitmap for each cell
				var cellBitmap = new createjs.Sprite(tilesetSheet);
				// layer data has single dimension array
				var idx = x + y * layerData.width;
				// tilemap data uses 1 as first value, EaselJS uses 0 (sub 1 to load correct tile)
				cellBitmap.gotoAndStop(layerData.data[idx] - 1);
				// isometrix tile positioning based on X Y order from Tiled
				cellBitmap.x = x * tilewidth;
				cellBitmap.y = y * tileheight;
				// add bitmap to stage
				this.stage.addChild(cellBitmap);
			}
		}
	}

	// utility function for loading assets from server
	function httpGet(theUrl) {
		var xmlHttp = null;
		xmlHttp = new XMLHttpRequest();
		xmlHttp.open("GET", theUrl, false);
		xmlHttp.send(null);
		return xmlHttp.responseText;
	}

	// utility function for loading json data from server
	function httpGetData(theUrl) {
		var responseText = httpGet(theUrl);
		return JSON.parse(responseText);
	}

	

window.Level = Level;

}(window));