(function(){

	Phone.apps['darkweb']       = {};
	const app                    = Phone.apps['darkweb'];

	app.open = function(data) {
		
	}

	app.move = function(direction) {
		switch(direction) {
			case 'TOP':
				return;
			case 'DOWN':
				return;
			default:
				return;
		}
	}

	app.enter = function() {
		console.log('hi');
	}

})();
