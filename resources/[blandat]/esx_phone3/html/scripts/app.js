(function(){
	window.Phone      = {};
	Phone.apps        = {};
	Phone.opened      = [];
	Phone.contacts    = [];
	Phone.messages    = [];
	Phone.appData     = {};
	Phone.hiddenIcons = { };
	Phone.settings 	  = { openedApps: []};

	Phone.contacts.sort((a,b) => a.name.localeCompare(b.name));

	Phone.move = function(direction) {

		const currrent = this.current();

		if(currrent != null)
			this.apps[currrent].move(direction);

	}

	Phone.enter = function(direction) {

		const currrent = this.current();

		if(currrent != null)
			this.apps[currrent].enter();
	}

	Phone.open = function(appName, data = {}) {

		Phone.appData[appName] = data;
		Phone.opened.push(appName);

		/* Count open apps */
		if(!Phone.settings.openedApps.includes(appName) && appName !== 'home'){
			Phone.settings.openedApps.push(appName);
		}

		Phone.apps[appName].open(data);

		$('.app').hide();
		$('#app-' + appName).show();

		if(appName === 'settings' || appName === 'your-car'){
			/* Set color of status bar */
			$('.status-bar').css('background', '#fefefe').css('color', '#232323');
			$('.status-bar ul.signal li').css('background', '#333');
			$('.status-bar ul.signal li:nth-child(4)').css('background', '#999');
			$('.status-bar ul.signal li:nth-child(5)').css('background', '#999');
		} else {
			$('.status-bar ul.signal li').css('background', '');
			$('.status-bar').css('background', '').css('color', '');
		}

	}

	Phone.addContact = function(name, number) {
		this.contacts.push({name, number});
		this.contacts.sort((a,b) => a.name.localeCompare(b.name));
	}

	Phone.openPrompt = function(available, number) {
		const currrent = this.current();

		if(currrent != null)
			this.apps[currrent].openPrompt(available, number);
	}
	Phone.update = function(data) {
		const currrent = this.current();

		if(currrent != null)
			this.apps[currrent].update(data);
	}

	Phone.close = function() {

		const currrent = this.current();

		if(currrent != null) {

			if(typeof this.apps[this.current()].close != 'undefined') {

				const canClose = this.apps[this.current()].close();

				if(canClose) {

					this.opened.pop();

					if(this.opened.length > 0) {

						Phone.apps[this.current()].open(this.appData[this.current()]);

						$('.app').hide();
						$('#app-' + this.current()).show();
					}

				}
			} else {

				this.opened.pop();

				if(this.opened.length > 0) {

					Phone.apps[this.current()].open(this.appData[this.current()]);

					$('.app').hide();
					$('#app-' + this.current()).show();
				}	else {
					$.post('http://esx_phone3/escape');
					$('#phone').hide();
				}

			}

		}

	}

	Phone.current = function() {
		return this.opened[this.opened.length - 1] || null;
	}

	document.onkeyup = function(e) {

		switch(e.which) {

			// ESC
			case 27 : {
				Phone.close();
				break;
			}

			// BACKSPACE
			// case 27 : {
			// 	Phone.close();
			// 	break;
			// }

		    // ENTREE
		    case 13: {
		    	Phone.enter();
		    	break;
		    }

/*	    // G
	    case 71: {

				if(Phone.current() === 'contact-action-message') {
					Phone.apps['contact-action-message'].activateGPS()
				}

	    	break;
	    }
*/

		}

	}

	document.onkeydown = function (e) {

		if(Phone.current() == 'settings' && Phone.settings.inputIsActive && (e.which === 38 || e.which === 40)){
			console.log('Prevented falsly movement with arrows.');
			return;
		}

		switch(e.which) {

	    // FLECHE HAUT
	    case 38: {
	    	Phone.move('TOP');
	    	break;
	    }

	    // FLECHE BAS
	    case 40: {
	    	Phone.move('DOWN');
	    	break;
	    }

	    // FLECHE GAUCHE
	    case 37: {
				Phone.move('LEFT');
	    	break;
	    }

	    // FLECHE DROITE
	    case 39: {
	    	Phone.move('RIGHT');
	    	break;
	    }

	    // FLECHE DROITE
	    case 8: {
			if(Phone.current() == 'settings'){
				Phone.close();
			}
	    	break;
	    }

	    default: break;

	  }

	};

	window.onData = function(data){
		if(data.controlPressed === true) {
			if(Phone.settings.inputIsActive && (data.control === 'BACKSPACE' || data.control === 'TOP' || data.control === 'DOWN')){
				console.log('Prevented falsly close of application.');
				return;
			}
			switch(data.control) {

				case 'TOP'       : Phone.move('TOP');   break;
				case 'DOWN'      : Phone.move('DOWN');  break;
				case 'LEFT'      : Phone.move('LEFT');  break;
				case 'RIGHT'     : Phone.move('RIGHT'); break;
				case 'ENTER'     : Phone.enter();       break;
				case 'BACKSPACE' : Phone.close();       break;

				default: break;

			}

		}
		console.log('recieved data');

		if(data.darkweb === true){
			console.log('Darkweb messages: ' + JSON.stringify(data.messages))
			Phone.update(data.messages)
		}

		if(data.updateVehicles === true){
			console.log('app.js: Updating vehicles');
			if(!data.vehicles.length){
				console.log('No vehicles found what so ever lul');
			} else {
				data.type = 'ALL';
				Phone.update(data);
			}
		} else if(data.updateCurrentVehicle === true){
			data.type = 'CURRENT';
			Phone.update(data);
		}

		if(data.numberCheck === true){
			if(data.numberData.available === true){
				console.log('Numret var ledigt.');
				Phone.openPrompt(true, data.numberData.number);
			} else if(data.numberData.available === false){
				console.log('Numret var upptaget.');
				Phone.openPrompt(false, data.numberData.number);
			}
		}

		if(data.showPhone === true) {
			if(!Phone.phoneNumber){
				Phone.phoneNumber = 'Hämtar..';
			}

			if(data.openApp){
				Phone.open(data.openApp);
			} else {
				Phone.opened.length = 0;
				Phone.open('home');
			}

			$('#phone').show();

		}

		if(data.showPhone === false) {
			$('#phone').hide();
		}

		if(data.reloadPhone == true) {
			$('#app-home .menu-icon-darkweb .menu-icon-inner').hide();
			Phone.encryptingCard 	= data.phoneData.encryptingCard;
			Phone.identifier 	 	= data.phoneData.identifier;
			Phone.contacts.length 	= 0;

			if(Phone.encryptingCard == true){
				$('#app-home .menu-icon-darkweb .menu-icon-inner').show();
				$('#app-home .menu-icon-darkweb').addClass('menu-icon');
			} else {
				$('#app-home .menu-icon-darkweb').removeClass('menu-icon');
			}

			$('#app-contacts .contact-me .contact-number').text('070-' + data.phoneData.phoneNumber);

			for(let i=0; i<data.phoneData.contacts.length; i++)
				Phone.addContact(data.phoneData.contacts[i].name, data.phoneData.contacts[i].number);

			for(let k in Phone.hiddenIcons)
				if(Phone.hiddenIcons.hasOwnProperty(k))
					$('#app-home .menu-icon-' + k).hide();
		}

		if(data.reloadSettings === true){
			loadSettings(data.settings);
		}

		if(data.incomingCall === true) {

			let name = '';

			for(let i=0; i<Phone.contacts.length; i++)
				if(Phone.contacts[i].number == data.number)
					name = Phone.contacts[i].name;

			Phone.open('incoming-call', {
				name   : name,
				target : data.target,
				channel: data.channel,
				number : data.number,
			});

		}

		if(data.acceptedCall === true) {
			Phone.apps['contact-action-call'].startCall(data.channel, data.target);
		}

		if(data.endCall === true) {
			Phone.close();
		}

		if(data.showIcon === true) {
			delete Phone.hiddenIcons[data.icon];
			$('#app-home .menu-icon-' + data.icon).show();
		}

		if(data.showIcon === false) {
			Phone.hiddenIcons[data.icon] = true;
			$('#app-home .menu-icon-' + data.icon).hide();
		}

		if(data.newMessage === true) {

			const date = new Date();

			Phone.messages.push({
				number   : data.phoneNumber,
				body     : data.message,
				position : data.position,
				anon     : data.anon,
				job      : data.job,
				self     : false,
				time     : date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0'),
				timestamp: +date,
				read     : false,
			})

			Phone.apps['contact-action-message'].updateMessages();

		}

		if(data.contactAdded === true) {
			Phone.addContact(data.name, data.number);
		}

		if(data.activateGPS === true && Phone.current() === 'contact-action-message') {
			Phone.apps['contact-action-message'].activateGPS()
		}

		if(data.setBank === true) {

			$('#app-bank .balance').removeClass('positive negative').text(data.money);

			if(data.money >= 0)
				$('#app-bank .balance').addClass('positive');
			else
				$('#app-bank .balance').addClass('negative');

		}

		if(data.onPlayers === true) {
			switch(data.reason) {

				case 'bank_transfer' : {

					Phone.open('bank-transfer', data.players)

					break;
				}

				default: break;

			}
		}

	}

	/* Functions */

	function loadSettings(settings){
		console.log('Loading settings.');
		Phone.settings = {
			...Phone.settings,
			...settings
		}

		if(settings.flightmode){
			$('.status-bar ul.signal').hide();
			$('.status-bar .plane').show()
			$.post('http://esx_phone3/set_flightmode', JSON.stringify(true))
		} else {
			$('.status-bar ul.signal').show();
			$('.status-bar .plane').hide();
			$.post('http://esx_phone3/set_flightmode', JSON.stringify(false))
		}

		/* Theme */
		if(settings.themeID){
			$('#app-home .menu-icon-inner').addClass('theme' + settings.themeID);
		}

		/* Background */
		let background = settings.background;
		if(background){
			if(background.url.includes('http')){
				$('#screen').css('background-image', 'url("' + background.url + '")');
			} else {
				$('#screen').css('background-image', 'url(' + background.url + ')');
			}
			$('#app-home .menu-icon-label').css('color', background.textColor === 'dark' ? '#000' : '#fefefe');
			$('#app-home .menu-icon-label').css('text-shadow', background.textColor === 'dark' ? '1px 1px 2px #fff' : '1px 2px #444');
		}

	}

	window.onload = function(e){
		window.addEventListener('message', function(event){
			onData(event.data);
		});

		/* Adding browswer open phone key, cba to look for the other one support for  development of apps */


		/* 				case 'TOP'       : Phone.move('TOP');   break;
						case 'DOWN'      : Phone.move('DOWN');  break;
						case 'LEFT'      : Phone.move('LEFT');  break;
						case 'RIGHT'     : Phone.move('RIGHT'); break;
						case 'ENTER'     : Phone.enter();       break;
						case 'BACKSPACE' : Phone.close();       break; */

	}

	$('.app').addClass('animated zoomIn');

	setInterval(() => {

		const date = new Date;

		$('.status-bar .time .hour')  .text(date.getHours()  .toString().padStart(2, '0'));
		$('.status-bar .time .minute').text(date.getMinutes().toString().padStart(2, '0'));

	}, 1000);

})();
