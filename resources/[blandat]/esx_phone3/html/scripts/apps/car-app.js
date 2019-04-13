
(function(){

	Phone.apps['your-car'] = {};
	const app = Phone.apps['your-car'];
	let forcereload;
	app.loadingState = 'NO_DATA';
	app.lastUpdated;
	app.updateTime = 30000;
    app.currentVehicle;
    app.first = false;
	app.oldstate = 'NO_DATA';
	app.vehicles = [];
	app.returnToOldState = false;
	app.showCarFirst = 0;


	app.update = function(data){
        console.log('UPDATING, DATA IS ' + data);
		if(data){
            let type = data.type;
            console.log('UPDATING, TYPE IS ' + type);

			console.log(JSON.stringify(data));
			if(type === 'CURRENT'){
				console.log('Updated current vehicle.');
				app.currentVehicle = data.vehicleData;
				app.loadingState = 'GOT_DATA';
				updateInfo();

			} else if(type === 'ALL'){
				console.log('Updated ALL data.');
				app.loadingState = 'GOT_DATA';
                console.log('Data: ')
                console.log(JSON.stringify(data))

				app.vehicles = data.vehicles;
				/* Set current vehicle here */
				app.showCarFirst = data.first;
				app.vehicleData = data.vehicles[app.showCarFirst];
				console.log('data.vehicles = ' + JSON.stringify(data.vehicles));
				console.log('app.vehicledata = ' + JSON.stringify(app.vehicleData));
				console.log('data.first = ' + JSON.stringify(data.first));
                // if(data.vehicle){
				// 	if(!app.currentVehicle){
				// 		app.currentVehicle = {}
				// 	}
                //     app.currentVehicle.vehicle = data.vehicle - 0;
                //     app.currentVehicle.lock = data.lock - 0;
                // }
				updateInfo();
			}


		} else if(app.lastUpdated + app.updateTime < Date.now() && !app.currentVehicle && !app.vehicleData || !app.lastUpdated){
			console.log('Updating!');
			app.lastUpdated = Date.now();
			app.loadingState = 'INITIAL_LOADING';
			$.post('http://esx_phone3/request_vehicle_data');
		} else {
			console.log('Not updating. Only updating every '+ app.updateTime/1000 +' seconds.');
		}

		setTimeout(function(){
			if(app.loadingState == 'INITIAL_LOADING' || app.loadingState == 'NO_DATA'){
				app.loadingState = 'NO_CAR_FOUND';
				updateState();
			}
		}, 4200);

		updateState();
	}

	app.open = function(data) {

        /* First time loading app? */
        if(!app.first){
            initClickEvents();
            app.first = true;
        }

        app.update();

        /* Update state */
        updateState();
	}

	app.close = function() {

		if($('#select-your-car:visible').length){
			clearSelectingCar();
			app.loadingState = app.oldstate;
			updateState();
		} else {

			clearActive();
			$('.status-bar ul.signal li').css('background', '');
			$('.status-bar').css('background', '').css('color', '');
			$('.spinner .loadingSpan').text('Laddar bilar');
			$('#no-car-found-div .noCarFoundText').text('Tyvärr kunde vi inte hitta någon bil registerad i ditt namn. Vänligen besök närmsta bilhandlare och inhandla ett fordon eller försök igen vid ett senare tillfälle. ');
			$('#no-car-found-div .noCarFoundText2').text('Om du tror detta är ett misstag kan du söka efter bilar i din närhet.');
			$('.find-car-near-button').text('Sök omkring dig');

			updateState();
			$.post('http://esx_phone3/release_focus');
			return true;
		}
	}

	app.move = function(direction) {
		console.log('MOVING' + direction);
		switch(direction) {
			case 'TOP':
				return goTop();
			case 'DOWN':
				return goDown()
		}
	}

	app.enter = function(currentAction) {

		$('.menuItem.active:visible').trigger('click');

	}



	/* Navigation functions */
	function goTop() {

		let curr = $('#app-your-car .menuItem.active:visible');

		if(curr.length){

			if(!curr.prev().hasClass('menuItem')){
				curr.removeClass('active');

				if(curr.hasClass('changeCarButton menuItem') || curr.is(':first-child') || $('#select-your-car:visible').length){
					$('#app-your-car .menuItem:visible').last().addClass('active');
				} else {
					$('.changeCarButton.menuItem').addClass('active');
				}

			} else {
				curr.removeClass('active')
				if(!curr.prev().is(':visible')){
					if(!curr.prev().prev().is(':visible')){
						curr = curr.prev().prev();
					} else {
						curr = curr.prev();
					}
				}
				curr.prev().addClass('active');

			}
		} else {
			$('#app-your-car .menuItem:visible').last().addClass('active');
		}

		let doc = document.getElementsByClassName('menuItem active');
		if(doc.length){
			doc[0].scrollIntoView({
				behavior: "smooth",
				block: "center",
				inline: 'start'
			});
		}
	}

	function goDown() {

		let curr = $('#app-your-car .menuItem.active:visible');
		if(curr.length){
			if(!curr.next().hasClass('menuItem') || curr.hasClass('changeCarButton menuItem')){
				curr.removeClass('active');
				if(curr.hasClass('changeCarButton menuItem') || $('#select-your-car:visible').length){
					$('#app-your-car div.menuItem:visible').first().addClass('active');
				} else {
					$('.changeCarButton.menuItem').addClass('active');
				}
			} else {
				curr.removeClass('active')
				if(!curr.next().is(':visible')){
					if(!curr.next().next().is(':visible')){
						curr = curr.next().next();
					} else {
						curr = curr.next();
					}
				}
				curr.next().addClass('active');
			}
		} else {
			$('#app-your-car .menuItem:visible').first().addClass('active');
		}

		let doc = document.getElementsByClassName('menuItem active');
		if(doc.length){
			doc[0].scrollIntoView({
				behavior: "smooth",
				block: "center"
			});
		}
	}

	/* Functions */
	function clearActive(){
		$('.active').removeClass('active');
	}

	function startLooking(list){
		console.log('Looking for plates from app.vehicles');
		$.post('http://esx_phone3/search_nearby', JSON.stringify(list));
		// if(app.currentVehicle){
		// 	console.log('App.currentVehicle is something. That is bad.');
		// 	if(app.currentVehicle.plate !== plate){
		// 		$.post('http://esx_phone3/update_current_vehicle', JSON.stringify(plate));
		// 	}
		// } else {
		// 	// $.post('http://esx_phone3/update_current_vehicle', JSON.stringify(plate));
		//
		// }
	}

	function updateCurrentVehicle(){
		if(!app.currentVehicle){
			return false;
		}
		app.loadingState = 'LOADING';
		updateState();
		$('.spinner .loadingSpan').text('Uppdaterar status');
		setTimeout(function(){
			$.post('http://esx_phone3/update_current_vehicle_known', JSON.stringify(app.currentVehicle.vehicle));
		}, 1400);
		setTimeout(function(){
			if(app.loadingState = 'LOADING'){
				app.loadingState = 'GOT_DATA';
			}
		}, 4400)
	}

	function updateInfo(){
		let vehicle = app.vehicleData;

		if(!vehicle && !app.currentVehicle){
			app.loadingState = 'NO_CAR_FOUND';
			return;
		}
		let health;
		if(app.currentVehicle){
			health = (app.currentVehicle.health + app.currentVehicle.engineHealth) / 2;

			if (health < 0) health = 0;

		} else if(vehicle){
			health = vehicle.health;
		}
        // console.log('currentVehicle:' + JSON.stringify(app.currentVehicle));
        // console.log('lock: ' + JSON.stringify(app.currentVehicle.lock));
        // console.log('veh: ' + JSON.stringify(app.currentVehicle.vehicle));
        // console.log('typeof: ' + typeof app.currentVehicle.vehicle + typeof app.currentVehicle.lock);
        // console.log('Updating info on display');

		/* Hide submenus */
		$('.submenu').removeClass('submenu');
		$('.small').hide();
		$('.warningIcon').removeClass('menuItem');
		$('#warning-message-icon').hide();

		/* Update info */

		if(app.currentVehicle){
			if(app.currentVehicle.engineHealth < 900){
				$('.warningIcon').addClass('menuItem');
				$('#warning-message-icon').show();
			}
		}

		$('.carHeadInfo > span').text(vehicle.name);
		$('.carHeadInfo > h1').text(vehicle.plate);
        console.log('Current vehicle: ');
        console.log(JSON.stringify(app.currentVehicle));
		$('#sharedKeys').text(app.currentVehicle ? '1 Aktiv' : '0 Aktiva');

        $('#lockStatus').text(!app.currentVehicle ? 'Garaget' : app.currentVehicle.lock === 0 || app.currentVehicle.lock === 1 ? 'Olåst' : 'Låst');

        $('#car-engine').text(!app.currentVehicle ? 'Ej tillgänglig' : app.currentVehicle.engineOn === 1 ? 'På' : 'Av');

        $('#car-fuel').text(!app.currentVehicle ? 'Ej tillgänglig' : app.currentVehicle.fuel + '%');

		$('#dirtlevel').text(((vehicle.dirtLevel / 15) * 100).toFixed(1) + '%');

		$('#condition').text((health / 10).toFixed(1) + '%');
		console.log('Vehicle health: ' + health)
		/* If condition < 60, if condition < 10 */
		if(health <= 950){
			$('#condition').parent().parent().addClass('submenu');
			$('#request-mechanic').parent().parent().show();
		}
		if(health <= 400){
			$('#request-mechanic').parent().parent().addClass('submenu').show();
			$('#request-towing').parent().parent().show();
		}


        $('#show-on-map').text(!app.currentVehicle ? 'Ej tillgänglig' : app.currentVehicle.showOnMap === true ? 'Göm från kartan' : 'Markera på kartan');
		$('#car-alarm').text(app.currentVehicle ? 'Tuta lite' : 'Ej tillgänglig');

		$('#car-doors').text(app.currentVehicle ? 'Öppna/stäng dörrar' : 'Ej tillgänglig')

		console.log('App is: ', app);

	}

	function updateState(){
		if(app.loadingState == 'LOADING' || app.loadingState === 'NO_DATA' || app.loadingState === 'INITIAL_LOADING'){
			$('.spinner').show();
			$('.your-car-main').hide();
            $('.changeCarButton').removeClass('menuItem').hide();
            $('#no-car-found-div').hide();
			$('#select-your-car').hide();
		} else if(app.loadingState === 'GOT_DATA'){
			$('.spinner').hide();
            $('.changeCarButton').addClass('menuItem').show();
            $('.your-car-main').show();
            $('#no-car-found-div').hide();
			$('#select-your-car').hide();
		} else if(app.loadingState === 'NO_CAR_FOUND'){
            $('.spinner').hide();
            $('.your-car-main').hide();
            $('.changeCarButton').removeClass('menuItem').hide();
            $('#no-car-found-div').show();
			$('#select-your-car').hide();
        } else if(app.loadingState === 'SELECTING_CAR'){
			$('#select-your-car').show();
			$('.spinner').hide();
			$('.your-car-main').hide();
			$('.changeCarButton').removeClass('menuItem').hide();
			$('#no-car-found-div').hide();
		}
	}

	function openSelectYourCar(){
		console.log('Triggered');
		let selectCarDiv = $('#select-your-car');

		$.each(app.vehicles, (index, item) => {
			console.log('One car spotted!');

			let veryTemporaryDiv = $('<div />')
			.addClass('menuItem')
			.appendTo(selectCarDiv)
			.click(e => {
				app.showCarFirst = index;
				setActiveVehicle(item.plate);
			})

			$('<span/>')
			.text(item.name)
			.appendTo(veryTemporaryDiv)

			$('<span/>')
			.text(item.plate)
			.appendTo(veryTemporaryDiv)

		});

		$('<button />')
		.text('Uppdatera')
		.addClass('find-car-near-button menuItem')
		.appendTo(selectCarDiv)
		.click(updateCarList)

		app.oldstate = app.loadingState;
		app.loadingState = 'SELECTING_CAR';
		updateState();
	}

	function initClickEvents(){

		$('.changeCarButton.menuItem').click(e => {
			openSelectYourCar();
		});

		$('#request-mechanic').parent().parent().click(e => {
			callMechanic();
		})
		$('#request-towing').parent().parent().click(e => {
			callMechanic(true);
		})

		$('#update-current-vehicle').parent().parent().click(e => {
			updateCurrentVehicle();
		});
		$('#car-engine').parent().parent().click(e => {
			toggleVehicleEngine();
		});


		$('#find-car-near-back-button').click(e => {
			if(app.vehicles.length){
				app.loadingState = 'SELECTING_CAR';
				updateState();
			} else {
				app.close();
				Phone.open('home');
			}
		});

        $('.find-car-near-button.menuItem').click(e => {
			searchNearby();
        })

		$('#sharedKeys').parent().parent().click(e => {

		})
		$('#car-alarm').parent().parent().click(e => {
			$.post('http://esx_phone3/test_honk', JSON.stringify(app.currentVehicle.vehicle));
		})

		$('#show-on-map').parent().parent().click(e => {
			if(app.currentVehicle){
				if(app.currentVehicle.showOnMap === true){
					app.currentVehicle.showOnMap = false;
					updateInfo();
					$.post('http://esx_phone3/hide_vehicle_blip');
				} else {
					app.currentVehicle.showOnMap = true;
					updateInfo();
					$.post('http://esx_phone3/show_vehicle_blip', JSON.stringify(app.currentVehicle.vehicle));
				}
			}
		})

		$('#lockStatus').parent().parent().click(e => {
            if(!app.currentVehicle) return;

			if(app.currentVehicle.lock === 0 || app.currentVehicle.lock === 1){
                app.currentVehicle.lock = 2;
				$.post('http://esx_phone3/lock_car', JSON.stringify(app.currentVehicle.vehicle));
			} else if(app.currentVehicle.lock === 2){
                app.currentVehicle.lock = 0;
				$.post('http://esx_phone3/unlock_car', JSON.stringify(app.currentVehicle.vehicle));
			}
            updateInfo();
		});

		$('#alarm').parent().parent().click(e => {
            if(!app.currentVehicle) return;

			$.post('http://esx_phone3/test_alarm', JSON.stringify(app.currentVehicle.vehicle));
		});
	}

	function toggleVehicleEngine(){
		console.log('Toggling engine. Once');
		if(!app.currentVehicle){
			return false;
		}
		console.log('Toggling engine. Twice');
		if(app.currentVehicle.engineOn === 1){
			app.currentVehicle.engineOn = 0;
			$.post('http://esx_phone3/set_engine_off', JSON.stringify(app.currentVehicle.vehicle));
		} else {
			app.currentVehicle.engineOn = 1;
			$.post('http://esx_phone3/set_engine_on', JSON.stringify(app.currentVehicle.vehicle));
		}
		updateInfo();
	}

	function setActiveVehicle(plate){
		console.log('Plate is: ' + plate);
		let found = app.vehicles.find(x => x.plate === plate);
		if(found){
			console.log('Found!, setting');
			app.vehicleData = found;
			app.close();
			app.currentVehicle = null;
			/* Request this vehicle to be set as current */
			$.post('http://esx_phone3/request_current_vehicle_data', JSON.stringify(found.plate));

		} else {
			/* Crash */
			console.log('Error.1337: Application could not find selected vehicle. ');
			Phone.open('home');
		}
		updateInfo();
	}

	function callMechanic(towing){
		console.log('Calling mechanic..');
		if(towing){
			$.post('http://esx_phone3/request_mechanic_towing', JSON.stringify(app.currentVehicle.vehicle));
		} else {
			$.post('http://esx_phone3/request_mechanic', JSON.stringify(app.currentVehicle.vehicle));
		}
	}

	function updateCarList(){
		app.loadingState = 'LOADING';
		app.oldstate = 'SELECTING_CAR';
		updateState();
		console.log('Updating car list from database.');
		clearSelectingCar();
		setTimeout(function(){
			$.post('http://esx_phone3/update_vehicle_list');
		}, 1200)
	}

	function clearSelectingCar(){
		$("#select-your-car").contents().filter(function(){
			return !$(this).is(':first-child');
		}).remove();
	}

	function searchNearby(){
		console.log('Searching for cars nearby.');
		app.loadingState = 'LOADING';
		$('.spinner .loadingSpan').text('Söker omkring dig');
		updateState();
		if(app.vehicles){
			startLooking(app.vehicles);
		}
		setTimeout(function(){
			if(app.loadingState === 'LOADING'){
				$('#no-car-found-div .noCarFoundText').text('Tyvärr kunde vi inte hitta någon bil i din närhet som står registrerad i ditt namn.');
				$('#no-car-found-div .noCarFoundText2').text('Vänligen försök igen eller återgå till framsidan.');
				$('.find-car-near-button').text('Försök igen');
				$('#find-car-near-back-button').show();
				app.loadingState = 'NO_CAR_FOUND';
				updateState();
			}
		}, 4000)
	}

	/* Check element scroll */

})();
