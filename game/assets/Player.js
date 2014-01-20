(function (window) {

	function Player(sprite) {
		this.initialize(sprite);
	}

	var p = Player.prototype = new createjs.Container();

// public properties:
	p.vX;
	p.vY;

	p.bounds;
	p.hit;

	p.lastKey;

	var MAX_VELOCITY = 20;

// constructor:
	p.Container_initialize = p.initialize;	//unique to avoid overiding base class

	p.initialize = function (sprite) {
		this.Container_initialize();

		this.playerBody = sprite;

		this.addChild(this.playerBody);

		//this.makeShape();
		this.vX = 0;
		this.vY = 0;
	}

// public methods:
	p.makeShape = function () {
		//draw ship body
		var g = this.playerBody.graphics;
		g.clear();
		g.beginStroke("#FFFFFF");

		g.moveTo(0, 10);	//nose
		g.lineTo(5, -6);	//rfin
		g.lineTo(0, -2);	//notch
		g.lineTo(-5, -6);	//lfin
		g.closePath(); // nose

		//furthest visual element
		this.bounds = 10;
		this.hit = this.bounds;
	}

	p.tick = function (event) {
		//move by velocity
		this.x += this.vX;
		this.y += this.vY;
	}

	p.accelerate = function (keys) {
		var view = this;
		view.vX = 0;
		view.vY = 0;
		var latestKey = false;;

		keys.forEach(function(key){
			if(key === 'left')
				view.vX += -MAX_VELOCITY;
			if(key === 'right')
				view.vX += MAX_VELOCITY;
			if(key === 'up')
				view.vY += -MAX_VELOCITY;
			if(key === 'down')
				view.vY += MAX_VELOCITY;
			latestKey = key;
		});

		if(latestKey !== false)
		{
			if(this.playerBody.currentAnimation !== 'run')
			{
				this.playerBody.gotoAndPlay('run')
			}
		}
		else
		{
			this.playerBody.gotoAndPlay('idle')
		}

		switch(latestKey){
			case 'left':
				if(this.playerBody.currentAnimation !== 'left')
				{
					this.playerBody.gotoAndPlay('left');
					this.lastKey = 'left';
				}
				break;
			case 'right':
				if(this.playerBody.currentAnimation !== 'right')
				{
					this.playerBody.gotoAndPlay('right');
					this.lastKey = 'right';
				}
				break;
			case 'up':
				if(this.playerBody.currentAnimation !== 'up')
				{
					this.playerBody.gotoAndPlay('up');
					this.lastKey = 'up';
				}
				break;
			case 'down':
				if(this.playerBody.currentAnimation !== 'down')
				{
					this.playerBody.gotoAndPlay('down');
					this.lastKey = 'down';
				}
				break;
			default:
				switch(this.lastKey){
					case 'left':
							this.playerBody.gotoAndPlay('left_idle');
						break;
					case 'up':
							this.playerBody.gotoAndPlay('up_idle');
						break;
					case 'down':
							this.playerBody.gotoAndPlay('down_idle');
						break;
					case 'right':
							this.playerBody.gotoAndPlay('right_idle');
						break;
					default:
						break;
				}
				break;
		}

		if(this.vX > MAX_VELOCITY)
			this.vX = MAX_VELOCITY;
		if(this.vX < -MAX_VELOCITY)
			this.vX = -MAX_VELOCITY;
		if(this.vY > MAX_VELOCITY)
			this.vY = MAX_VELOCITY;
		if(this.vY < -MAX_VELOCITY)
			this.vY = -MAX_VELOCITY;

	}

	window.Player = Player;

}(window));