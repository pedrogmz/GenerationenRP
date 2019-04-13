(function(){

	Phone.apps['settings'] 		= {};
	const app                 = Phone.apps['settings'];
	const settingsList				= [	{name: 'Flygplansläge', icon: 'fa-plane', type: 'TOGGLE'},
																{name: 'Bakgrunder', icon: 'fa-image', type: 'SUBMENU'},
																{name: 'Ringsignal', icon: 'fa-phone', type: 'SUBMENU'}];

	const backgroundList			= [	{name: 'Färger', url: 'https://s4827.pcdn.co/wp-content/uploads/2017/11/iphone_x_wallpaper_blur_2.jpg', textColor: 'light'},
																{name: 'Berg', url: 'https://i.pinimg.com/originals/78/dc/88/78dc886980d16501c017aad7b466f58f.jpg', textColor: 'light'},
																{name: 'Planet', url: 'https://fsb.zobj.net/crop.php?r=1QO91E3lAg93BOlstQnZpdJ1x3oADif7xfYDhx8fE27WUc4NDyNmkWUvorFrUUEktcHQDO6lnwAcChvX_VhZWu3MZbVYazjYe2Qws7XF56IhAt7Vf5VLCjGRVnJEkc5rtJ4FJ_EBgMPOzGIqR65nDUrPxEBhtVMTzqvg8qM9nNQILnZlPEubfjXOUKw', textColor: 'light'},
																{name: 'Klippor', url: 'https://i.pinimg.com/originals/30/c8/7f/30c87f263a346b69f337239dfeafae4b.jpg', textColor: 'light'},
																{name: 'Pulver', url: 'https://i.pinimg.com/236x/af/23/bd/af23bdfb48de8c986e9083f89932bee5--apple-illustration-apple-ipad.jpg', textColor: 'light'},
																{name: 'Jorden', url: 'https://earthnetworkdotnews.files.wordpress.com/2016/05/706.jpg', textColor: 'light'},
																{name: 'Vatten', url: 'https://i.pinimg.com/originals/98/11/1f/98111f27f1032cc5d855f78baf447cbb.jpg', textColor: 'light'},
																{name: 'Volvo', url: 'https://fsb.zobj.net/crop.php?r=cWay06oZMmwqtHIk9wRDiQfJZc_GLF4E6hw0DXEHolWztSgdekVHRHVKV2xgOw4djiHJe_xlhF3g0SFs7t2O0BBj2KLVB4CfvvTYTg88nzxjFJy2gj1mjv8ZNfqv9WFOa_U7fDVI3WW6AC_Aw3ervGZMjei-DOQuBMPCa90Sf6aJzs4ftdolNTN4fUM', textColor: 'light'},
																{name: 'BMW', url: 'https://i.pinimg.com/originals/fd/e2/1e/fde21e11f2e9c4aeb3fcc01759992942.jpg', textColor: 'light'},
																{name: 'Audi', url: 'https://fsb.zobj.net/crop.php?r=ky_YYaCcHvjvSvs-vyU2wqlRD_JYhrolpI33BAx3BtDjyvGu1zShcKq4xl5SP33riSnfMJ-l1jzEl1ZG1oIWs60Kp6151P2xFV9Ypc8uzu_0zv5Kkmj3jF0SQrxahF4OKb_7NEIvS_xcnes0Bys8_bSC8usOoopW0cDiVM6404QIGK13U6WZ868jseY', textColor: 'light'}, ]
	Phone.settings.flightmode 		= false;
	Phone.settings.sleepmode 		= false;
	let opened 						= false;
	Phone.settings.inputIsActive 	= false;
	Phone.settings.playingSound		= false;
	app.callSound;

  app.open = function(data) {
	  Phone.settings.inputIsActive 	= false;
		if(!opened){
			populateUL();
			opened = true;
		}
		$.post('http://esx_phone3/request_input_focus');
	}
	app.openPrompt = function(available, number){
		if(available === true){
			function f(){
				changeNumber(number)
				focusField('.numberInputField')
			}
			promptUser('success','Nummer ' + number + ' är ledigt!', 'Acceptera för att byta nummer till ' + number + '. Kom ihåg att du inte kan byta nummer igen på 7 dagar och att det kostar $5000.', false, undefined, undefined, f)
		} else {
			promptUser('failed','Nummer  ' + number + ' är tyvärr upptaget', 'Vänligen försök igen med ett annat nummer. ', true, 'Stäng', 0, f)
		}
	}

	app.close = function() {
		opened = false;
		Phone.settings.inputIsActive = false;

		stopSound();

		console.log('Closing settings.');
		let prompt = $('.promptDivWrapper:visible');
		if(prompt.length){
			console.log('Only closing prompt.');
			closePrompt();
			return;
		}

		if($('.displayChangePhoneNumberDiv').is(':visible') || $('.changeTuneDiv').is(':visible') || $('.playSoundDiv').is(':visible')){
			$('.displayChangePhoneNumberDiv').remove();
			$('.changeTuneDiv').remove();
			openSubMenu('RINGSIGNAL');
		} else if($('#app-settings .submenuDiv').is(':visible')){
			console.log('SUBMENU IS VISIBLE');
			$('#app-settings .settingsListWrapper').show();
			$('#app-settings .title').text('Settings');
			$('#app-settings .submenuDiv').hide().empty();
			$('.chevronBack').hide();
		} else {
			$('#app-settings .settingsListWrapper > ul').empty();
			$('.status-bar ul.signal li').css('background', '');
			$('.status-bar').css('background', '').css('color', '');
			$('#screen').css('border', '');

			$.post('http://esx_phone3/save_settings', JSON.stringify({
				identifier: Phone.identifier,
				settings: {
					flightmode: Phone.settings.flightmode,
					sleepmode: Phone.settings.sleepmode,
					callSound: Phone.settings.callSound,
					background: Phone.settings.background,
					themeID: Phone.settings.themeID
				}})
			);
			$.post('http://esx_phone3/release_focus');
			return true;
		}
	}

	app.selectElem = function(elem) {

	}

	app.move = function (direction) {
		let om = $('.omTelefonenWrapperDiv:visible');
		if(direction === 'DOWN'){
			if(om.length){
				var scrollTop = om.scrollTop();
				om.scrollTop(scrollTop + 15);
			}
			goDownInMenu();
		} else if(direction === 'TOP'){
			if(om.length){
				var scrollTop = om.scrollTop();
				om.scrollTop(scrollTop - 15);
			}
			goUpInMenu();
		} else if(direction === 'BACKSPACE'){
			console.log('BACKSPACE!!!');
			// app.close();
		}
		let prompt = $('.promptDivWrapper:visible');
		if(prompt.length){
			if(direction === 'LEFT' || direction === 'RIGHT' || direction === 'TOP' || direction === 'DOWN' ){
				togglePromtButton();
			}
		}
	}

	app.enter = function (){
		let curr = $('#app-settings .iterableListItem.active:visible');
		let prompt = $('.promptDivWrapper:visible');
		if(prompt.length){
			return;
		}
		/* Remove all actives */
		$('.iterableListItem .active').removeClass('active');

		if(curr.length) {
			curr.trigger('click');
		}
	}


	/* API functions */

	function openSubMenu(name){
		let mainMenu = $('.settingsListWrapper');
		let subMenu = $('#app-settings .submenuDiv');
		mainMenu.hide();

		/* Set title & show chevron */
		if(name.toUpperCase() === 'RINGSIGNAL'){
			$('#app-settings .title').text(name + ' - ' + (typeof Phone.phoneNumber === 'number' ? '#' + Phone.phoneNumber : Phone.phoneNumber));
		} else {
			$('#app-settings .title').text(name.replace('_', ' '));
		}
		$('.chevronBack').show();

		/* If a submenu already is showing, empty it and open a new one */
		if(subMenu.is(':visible')){
			subMenu.empty();
		}

		/* Settings based on different submenus below */
		switch (name.toUpperCase()) {
			case 'GENERELLA':
				let generellaList = [
					{name: 'Dela plats', icon: 'fa-map-marker', id: 'sharelocation'},
					{name: 'Gå med i Discord', icon: 'fa-headphones', id: 'discord'},
					{name: 'Rensa kontakter', icon: 'fa-address-book', id: 'clearcontacts'},
					{name: 'Stäng appar', icon: 'fa-window-close', id: 'applikationer'},
					{name: 'Återställ telefon', icon: 'fa-power-off', id: 'resetphone'},
					];
					// https://fontawesome.com/icons/power-off?style=solid
				$.each(generellaList, (index, item) => {
					let genDisplayDiv = $('<div />')
					.addClass('iterableListItem genDisplayDiv')
					.appendTo(subMenu)
					.click( e => {
						if(item.id === 'discord'){
							console.log('Trying to open discord invite link');
							copyToClipboard('https://discord.gg/2ReEwXd');
							promptUser('success', 'Discord-länken har kopierats', 'Länken som kopierats: https://discord.gg/2ReEwXd', true, 'Stäng', null, closePrompt, null);
							// let myWindow = window.open("steam://openurl/www.google.se", "Swedish Island Discord", "width=600,height=460")
							// myWindow.document.write("<p>This is 'my window'. I am 200px wide and 100px tall!</p>");
						} else if(item.id === 'sharelocation'){
							toggleShareLocation();
						} else if(item.id === 'resetphone'){
							resetPhone();
						} else if(item.id === 'applikationer'){
							Phone.settings.openedApps = ['settings'];
							app.close();
						}
					})

					$('<i />')
					.addClass('icon fa ' + item.icon)
					.appendTo(genDisplayDiv)

					let toggleSpanThing = $('<span />')
					.text(item.name)
					.appendTo(genDisplayDiv)

					if(item.id === 'sharelocation') {
						$('<i />')
						.addClass('toggleIcon fa fa-lg ' + (Phone.settings.sharelocation === true ? 'fa-toggle-on' : 'fa-toggle-off'))
						.appendTo(toggleSpanThing)
					}

				})

				subMenu.show();
				break;
			case 'BAKGRUNDER':
				opened = false;
				let ul = $('<ul/>')
				.addClass('bakgroundList')
				.appendTo(subMenu)

				$.each(backgroundList, item => {

					let li = $('<li/>')
					.text(backgroundList[item].name)
					.data(backgroundList[item])
					.addClass('iterableListItem backgroundMenuItem ' + name)
					.appendTo(ul)
					.click(event => {
						app.close();
						setPhoneBackground(backgroundList[item].url, backgroundList[item].textColor);
					})

					let span = $('<span/>')
					.text(backgroundList[item].size)
					.appendTo(li)
					.addClass('bakgrundSizeSpan')
				})
				subMenu.show();
				break;


			case 'RINGSIGNAL':
				let phoneSettingsList = ['Byt_ringsignal', 'Nuvarande_ringsignal']

				let phoneUL = $('<ul/>')
				.addClass('phoneMenuList')
				.appendTo(subMenu);

				$.each(phoneSettingsList, (index, item) => {
					let li = $('<li/>')
					.text(item.replace('_', ' '))
					.addClass('iterableListItem phoneMenuItem ' + item)
					.appendTo(phoneUL)
					.click( event => {
						openSubMenu(item);
					})
				})
				subMenu.show();
				break;

			case 'TEMAN':
				let themeList = [{name: 'Standard', id: 'standard'}, {name: 'Mörkt', id: 'dark'}, {name: 'Rosa', id: 'pink'}, {name: 'Rött', id: 'red'}, {name: 'Guld', id: 'gold'}, {name: 'Mörk gradient', id: 'darkbackground'}, {name: 'Ljus gradient', id: 'lightbackground'}]

				let themeUL = $('<ul/>')
				.addClass('themeList')
				.appendTo(subMenu);

				$.each(themeList, (index, item) => {
					let li = $('<li/>')
					.text(item.name.replace('_', ' '))
					.addClass('iterableListItem phoneMenuItem ' + item.id)
					.appendTo(themeUL)
					.click( event => {
						changeTheme(item.id, themeList);
					})
				})

				subMenu.show();
				break;

			case 'OM_TELEFONEN':

				let aboutPhoneList = [
									{title: 'Enhetens namn', text: 'iPhone 8'},
									{title: 'Aktiva applikationer', text: Phone.settings.openedApps.length},
									{title: 'Modelnummer', text: 'FRD-L09'},
									{title: 'Version', text: 'FRD-L09C532B450'},
									{title: 'iOS version', text: '11.4.1', margin: true},
									{title: 'CPU', text: 'Hexa-core (2x Monsoon + 4x Mistral)'},
									{title: 'RAM', text: '2,0 GB'},
									{title: 'Lagring', text: '256 GB'},

									];

				let infoDisplayDiv = $('<div />')
				.addClass('omTelefonenWrapperDiv')
				.appendTo(subMenu);

				console.log('What is phone? ', Phone);

				$.each(aboutPhoneList, (index, item) => {
					let listDiv = $('<div />')
					.addClass('listDiv ' + (item.margin ? 'margin' : null))
					.appendTo(infoDisplayDiv);

					let spanTitle = $('<span />')
					.text(item.title)
					.addClass('spanTitle')
					.appendTo(listDiv);

					let spanText = $('<span />')
					.text(item.text)
					.addClass('spanText')
					.appendTo(listDiv);
				});



				subMenu.show();
				break;

				/* Sub, sub menus */
			case 'BYT_TELEFONNUMMER':
				let displayDiv = $('<div />')
				.addClass('displayChangePhoneNumberDiv')
				.appendTo(subMenu);

				let changeNumberInput = $('<input />')
				.attr('placeholder', 'Ditt nya nummer..')
				.addClass('numberInputField')
				.appendTo(displayDiv)
				.focus()
				.on("focus", event => {
					Phone.settings.inputIsActive = true;
				})
				.on("blur", event => {
					Phone.settings.inputIsActive = false;
				})
				.keypress(e => {
					if(e.which === 13){
						/* enter */
						console.log('phonelog: blurring');
						// changeNumberInput.blur();
						getNumberAndPromptUser(changeNumberInput.val());
					}
				})
				Phone.settings.inputIsActive = true; // Because the first time on the "focus, it doesn't work"
				subMenu.show();
				break;
			case 'BYT_RINGSIGNAL':
				const tuneList = [ 	{ name: 'Original', text: '297 KB', fileurl: 'ogg/incoming-call.ogg'},
									{ name: 'Gammal telefon', text: '425.17 KB', fileurl: 'ogg/gammal.ogg'},
									{ name: 'Country roads', text: '290.38 KB', fileurl: 'ogg/croads.ogg'},
									{ name: 'Svambob fyrkant', text: '272.28 KB', fileurl: 'ogg/svampbob.ogg'},
									{ name: 'Modern', text: '208.64 KB', fileurl: 'ogg/modern.ogg'},
									{ name: 'Pop song', text: '289.98 KB', fileurl: 'ogg/songpop.ogg'}];

				let changeTuneDisplayDiv = $('<div />')
				.addClass('changeTuneDiv')
				.appendTo(subMenu)

				$.each(tuneList, (index, item) => {
					let tuneListDiv = $('<div />')
					.addClass('tuneListDiv iterableListItem')
					.appendTo(changeTuneDisplayDiv)
					.click( e => {
						changeTune(item.fileurl, item.name, item.text);
						app.close();
					})

					$('<span />')
					.text(item.name)
					.addClass('spanTitle')
					.appendTo(tuneListDiv)

					$('<span />')
					.text(item.text)
					.addClass('spanText')
					.appendTo(tuneListDiv)
				})

				break;
			case 'NUVARANDE_RINGSIGNAL':
				console.log('IS IT PLAYING ATM?' + Phone.settings.playingSound);
				let playSoundDiv = $('<div/>')
				.addClass('playSoundDiv')
				.appendTo(subMenu)

				$('<span/>')
				.text(Phone.settings.callSound ? Phone.settings.callSound.name : 'Original')
				.addClass('spanTitle')
				.appendTo(playSoundDiv);

				$('<span/>')
				.addClass('spanText')
				.text(Phone.settings.callSound ? Phone.settings.callSound.size : '297 KB')
				.appendTo(playSoundDiv);

				let playIcon = $('<i/>')
				.addClass('fa-2x fa playIcon iterableListItem ' + (Phone.settings.playingSound === true ? 'fa-pause-circle' : 'fa-play') )
				.appendTo(playSoundDiv)
				.click( e => {
					togglePlaySound();
				})


			default:
				return;
		}
	}

	function stopSound(){
		if(app.callSound){
			Phone.settings.playingSound = false;
			app.callSound.pause();
			app.callSound = null;
		}
	}
	function toggleShareLocation(){
		Phone.settings.sharelocation = !Phone.settings.sharelocation;

		let icon = $('.genDisplayDiv .toggleIcon');

		if(Phone.settings.sharelocation === true){
			icon.removeClass('fa-toggle-off').addClass('fa-toggle-on');
			$.post('http://esx_phone3/set_sharelocation', JSON.stringify(true));
		} else {
			icon.removeClass('fa-toggle-on').addClass('fa-toggle-off');
			$.post('http://esx_phone3/set_sharelocation', JSON.stringify(false));
		}

	}

	function togglePlaySound(onlyStop){
		/* Toggle */
		Phone.settings.playingSound = !Phone.settings.playingSound;

		/* Define icon */
		let icon = $('.playIcon');

		/* Change icon */
		if(Phone.settings.playingSound === true){
			icon.removeClass('fa-play').addClass('fa-pause-circle');

			if(Phone.settings.callSound){
				app.callSound = new Audio(Phone.settings.callSound.fileurl);
			} else {
				app.callSound = new Audio('ogg/incoming-call.ogg');
			}

			app.callSound.loop = true;

			app.callSound.play();

		} else {
			icon.removeClass('fa-pause-circle').addClass('fa-play')

			app.callSound.pause();
			app.callSound = null;
		}
	}

	function changeNumber(number){
		closePrompt();
		console.log('Ditt nya nummer är: ' + number);
		$.post('http://esx_phone3/bingo_updatenumber', number.toString());
	}

	function changeTune(fileurl, name, size){
		Phone.settings.callSound = {
			fileurl: fileurl,
		 	name: name,
			size: size};
		console.log('Du bytte ringsignal till: ' + fileurl);
	}

	function getNumberAndPromptUser(number){

		/* Explicit convert to int */
		number = number - 0;
		console.log('Getting number and prompting user. Number:', number, typeof number);
		console.log('Number length is: ', number.toString().length);

		function closeFunc(){
			focusField('.numberInputField');
			closePrompt();
		}

		if(typeof number !== 'number' || isNaN(number)){
			promptUser('failed', 'Nummer kan enbart bestå av siffror', 'Vänligen försök igen.', true, 'Stäng', 0, closeFunc);
			return;
		} else if(number.toString().length < 5){
			promptUser('failed', 'Numret var för kort', 'Ett nummer måste vara fem siffror. Vänligen försök igen.', true, 'Stäng', 0, closeFunc);
			return;
		} else if(number.toString().length > 5){
			promptUser('failed', 'Numret var för långt', 'Ett nummer måste vara fem siffror. Vänligen försök igen.', true, 'Stäng', 0, closeFunc);
			return;
		}
		console.log('Checking number with database.... ' + number);
		$.post('http://esx_phone3/bingo_checknumber', number.toString());
	}

	function focusField(param, delay = 0){
		setTimeout(function(){
			$(param).focus()
		}, delay)
	}

	function promptUser(type, message, infomessage, onlyaccept = false, acceptButtonText = 'Acceptera', cancelButtonText = 'Avbryt', acceptedCallback, canceledCallback){
		/* Prompt the user with a question / message and two buttons, acceptedCallback / canceledCallback */
		let screenDiv = $('#app-settings');

		let promptDivWrapper = $('<div/>')
		.addClass('promptDivWrapper')
		.appendTo(screenDiv)

		let promptInnerDiv = $('<div />')
		.addClass('promptInnerDiv ' + type)
		.appendTo(promptDivWrapper)

		let promptMessage = $('<span/>')
		.addClass('promptMessage')
		.text(message)
		.appendTo(promptInnerDiv)

		let promptIcon = $('<i/>')
		.addClass('promptIcon fa fa-2x ' + (type === 'success' ? 'fa-check' : 'fa-times'))
		.appendTo(promptInnerDiv)

		let promptInfoMessage = $('<span/>')
		.addClass('promptInfoMessage')
		.text(infomessage)
		.appendTo(promptInnerDiv)

		let buttonDiv = $('<div />')
		.addClass('promptButtonDiv')
		.appendTo(promptInnerDiv)

		/* Append buttons */
		let acceptButton = $('<button />')
		.text(acceptButtonText)
		.addClass('promptButton ' + (onlyaccept ? 'orangeButton' : 'greenButton'))
		.appendTo(buttonDiv)
		.click(e => {
			acceptedCallback();
		})

		setTimeout(function(){
			acceptButton.focus()
		}, 100)

		if(!onlyaccept){
			let cancelButton = $('<button />')
			.text(cancelButtonText)
			.addClass('promptButton redButton')
			.appendTo(buttonDiv)
		}
	}

	/* Prompt functions, essentials */
	function closePrompt(){
		let prompt = $('.promptDivWrapper');
		console.log('Prompt is: ', prompt);
		if(prompt.length){
			prompt.remove();
		}
	}

	function togglePromtButton(){
		console.log('Toggling prompt button');
		let activePromptButton = $('.promptButton.active');
		if(activePromptButton.length){
			$('.promptButton').not('.active').addClass('active');
			activePromptButton.removeClass('active');
		} else if($('.promptButton').length){
			$('.promptButton').first().addClass('active');
		}
	}

	function toggleSetting(name){

		/* Change icon and toggle status */
		let toggle = $('i.'+name.toUpperCase())

		if(toggle.hasClass('fa-toggle-off')){
			toggle.removeClass('fa-toggle-off').addClass('fa-toggle-on')
		} else {
			toggle.removeClass('fa-toggle-on').addClass('fa-toggle-off')
		}

		switch (name.toUpperCase()) {
			case 'FLYGPLANSLÄGE':
				Phone.settings.flightmode = !Phone.settings.flightmode;

				if(Phone.settings.flightmode){
					console.log('Hiding signal!');
					$('.status-bar ul.signal').hide();
					$('.status-bar .plane').show()
					$.post('http://esx_phone3/set_flightmode', JSON.stringify(true))
				} else {
					console.log('Showing signal!');
					$('.status-bar ul.signal').show();
					$('.status-bar .plane').hide();
					$.post('http://esx_phone3/set_flightmode', JSON.stringify(false))
				}
				break;
			case 'STÖR_EJ':
				Phone.settings.sleepmode = !Phone.settings.sleepmode;
				break;
			default:
				return;
		}
	}

	/* Menu movement functions */
	function goDownInMenu() {

		let curr = $('#app-settings .iterableListItem.active:visible');
		if(curr.length){
			if(curr.is(':last-child')){
				curr.removeClass('active');
				$('#app-settings .iterableListItem:visible').first().addClass('active');
			} else {
				curr.removeClass('active').next().addClass('active');
			}
		} else {
			$('#app-settings .iterableListItem:visible').first().addClass('active');
		}
	}

	function goUpInMenu() {
		let curr = $('#app-settings .iterableListItem.active:visible');
		if(curr.length){
			if(curr.is(':first-child')){
				curr.removeClass('active');
				$('#app-settings .iterableListItem:visible').last().addClass('active');
			} else {
				curr.removeClass('active').prev().addClass('active');
			}
		} else {
			$('#app-settings .iterableListItem:visible').last().addClass('active');
		}
	}

	function setPhoneBackground(url, textColor){
		console.log('Background set')
		/* background-image: url('../img/backgroundPhone.png'); */
		// $('#screen').css('background-image', 'url(' + url + ');');

		if(!url){
			$('#screen').css('background-image', '');
			$('#app-home .menu-icon-label').css('color', '');
			return true;
		}

		Phone.settings.background = {url, textColor}

		if(url.includes('http')){
			$('#screen').css('background-image', 'url("' + url + '")');
		} else {
			$('#screen').css('background-image', 'url(' + url + ')');
		}
		$('#app-home .menu-icon-label').css('color', textColor === 'dark' ? '#121212' : '#fefefe');
		$('#app-home .menu-icon-label').css('text-shadow', textColor === 'dark' ? '1px 1px 2px #fff' : '1px 2px #444');
	}

	function populateUL(){
		console.log('POPULATING UL');
		let ul = $('#app-settings ul')
		$.each(settingsList, item => {

			let type = settingsList[item].type;
			let name = settingsList[item].name;

			let li = $('<li/>')
			.addClass('iterableListItem menuItem ' + type)
			.appendTo(ul)
			.click( event => { type === 'SUBMENU' ? openSubMenu(name) : toggleSetting(name)})

			let span = $('<span/>')
			.text(name.replace('_', ' '))
			.appendTo(li)

			let icon = $('<i/>')
			.addClass('icon fa fa-fw fa-sm ' + settingsList[item].icon)
			.prependTo(li);




			/* This can depend on flightmode or sleep mode */
			let iconClass;
			if(type === 'SUBMENU'){
				iconClass = 'fa-chevron-right';
			} else {
				/* toggle */
				let on = false;
				if(name.toUpperCase() === 'FLYGPLANSLÄGE'){
					if(Phone.settings.flightmode){
						on = true;
					}
				} else if(name.toUpperCase() === 'STÖR_EJ'){
					if(Phone.settings.sleepmode){
						on = true;
					}
				}
				iconClass = on ? 'fa-lg fa-toggle-on' : 'fa-lg fa-toggle-off'
			}

			let secondIcon = $('<i/>')
			.addClass('secondIcon fa fa-fw ' + iconClass + ' ' + name.toUpperCase())
			.appendTo(span);
		})
	}

	function changeTheme(id, themeList){

		Phone.settings.themeID = id;

		if(!id && !themeList){
			$('#app-home .menu-icon-inner').removeClass('themedark');
			$('#app-home .menu-icon-inner').removeClass('themepink');
			$('#app-home .menu-icon-inner').removeClass('themegold');
			$('#app-home .menu-icon-inner').removeClass('themered');
			$('#app-home .menu-icon-inner').removeClass('themedarkbackground');
			$('#app-home .menu-icon-inner').removeClass('themelightbackground');
			$('#app-home .menu-icon i').removeClass('themelightbackground');
		}

		app.close();
		$.each(themeList, (index, item) => {
			$(('.theme' + item.id)).removeClass(('theme' + item.id));
		})
		if(id === 'dark'){
			$('#app-home .menu-icon-inner').addClass('themedark');
		} else if(id === 'pink'){
			$('#app-home .menu-icon-inner').addClass('themepink');
		} else if(id === 'gold'){
			$('#app-home .menu-icon-inner').addClass('themegold');
		} else if(id === 'red'){
			$('#app-home .menu-icon-inner').addClass('themered');
		} else if(id === 'darkbackground'){
			$('#app-home .menu-icon-inner').addClass('themedarkbackground');
		} else if(id === 'lightbackground'){
			$('#app-home .menu-icon-inner').addClass('themelightbackground');
			$('#app-home .menu-icon i').addClass('themelightbackground');
		}
	}

	function resetPhone(){
		console.log('resetting phone...');
		console.log('phonesettings are: ', Phone.settings);
		console.log('Phone is: ', Phone);
		Phone.contacts = [];
		app.close();
		changeTheme(null, null);
		setPhoneBackground(null, null);
		changeTune('ogg/incoming-call.ogg', 'Original', '297 KB');
		$.post('http://esx_phone3/bingo_resetphone');
		$.post('http://esx_phone3/save_settings', JSON.stringify({identifier: Phone.identifier, settings: null}));
	}

	/* Copy to clipboard funtion */
	function copyToClipboard(text) {
		// create hidden text element, if it doesn't already exist
		var target = document.createElement("textarea");
		target.style.position = "absolute";
		target.style.left = "-9999px";
		target.style.top = "0";
		document.body.appendChild(target);
		target.textContent = text;
	    // select the content
	    var currentFocus = document.activeElement;
	    target.focus();
	    target.setSelectionRange(0, target.value.length);

	    // copy the selection
	    var succeed;
	    try {
	    	succeed = document.execCommand("copy");
	    } catch(e) {
	        succeed = false;
	    }

	    return succeed;
	}

})();
