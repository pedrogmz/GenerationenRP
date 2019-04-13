(function(){

	Phone.apps['darkweb']       = {};
	const app                    = Phone.apps['darkweb'];

	app.open = function(data) {
		$('.status-bar').hide();
		console.log('Opened darkweb');

		$.post('http://esx_phone3/darkweb_get_messages');

		// $.post('http://esx_phone3/darkweb_post_message', JSON.stringify({text: 'Started application..', time: Date.now()}))
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

	app.update = function(data){
		console.log('Updating messages')
		if(!data){
			return false;
		}
		let win = $('#chatwindow');
		win.empty();

		console.log('Updating messages: ' + JSON.stringify(data));

		let messages = data.slice(0, 25);

		$.each(messages, (index, message) => {
			let div = $('<div />').addClass('chatMessage').prependTo(win);
			let str = message.time.toString();
			let l = str.length;
			$('<span />').text((str.substring(l - 3, l)) + ':').appendTo(div);
			$('<span />').text(message.text).appendTo(div);
		});

		setTimeout(function(){
			$('#app-darkweb input').focus();
			$('#chatwindow').scrollTop($('#chatwindow')[0].scrollHeight);
		}, 100);

	}

	app.enter = function() {
		$.post('http://esx_phone3/request_input_focus');
	}
	app.close = function() {
		$('.status-bar').show();
		$.post('http://esx_phone3/release_focus');
		return true;
	}

	$('#app-darkweb input').keydown(e => {
		if(e.which == 13){
			let value = e.target.value;
			if(value.length > 2 && value.length < 255){
				let d = Date.now();
				$('#app-darkweb input').val('');
				$.post('http://esx_phone3/release_focus');
				$.post('http://esx_phone3/darkweb_post_message', JSON.stringify({text: value, time: d}))
				$('#chatwindow').scrollTop($('#chatwindow')[0].scrollHeight);
			} else {
				$('#chatwindow').scrollTop($('#chatwindow')[0].scrollHeight);
				$.post('http://esx_phone3/release_focus');
			}
		}
	})

})();
