(function(){

	Phone.apps['car-play']       = {};
	const app                    = Phone.apps['car-play'];
	const client_id = '0604a16cd7734fe799ecd6df34c270a7';
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
		$('#spotifyLoginButton').text('Kommer snart')
	}

	app.close = function() {
		$('#spotifyLoginButton').text('Logga in');
		return true;
	}
})();
