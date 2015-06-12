var http = require('http');
var Brig = require('brig');
var pcsc = require('pcsclite');
var events = require('events');

var eventEngine = new events.EventEmitter();

var pcsc = pcsc();
pcsc.on('reader', function(reader) {
	console.log('Detected ' + reader.name);

	reader.on('status', function(status) {
		var changes = this.state ^ status.state;
		if (!changes)
			return;

		// Card removed
		if ((changes & this.SCARD_STATE_EMPTY) && (status.state & this.SCARD_STATE_EMPTY)) {
			reader.disconnect(reader.SCARD_LEAVE_CARD, function(err) {
				console.log('Card removed');
				eventEngine.emit('removed');

			});
			return;
		}

		// Detected card
		if ((changes & this.SCARD_STATE_PRESENT) && (status.state & this.SCARD_STATE_PRESENT)) {
			console.log('Detected card');
			reader.connect({ share_mode : this.SCARD_SHARE_SHARED }, function(err, protocol) {
				if (err) {
					console.err(err);
					return;
				}

				// Getting serial number
				reader.transmit(new Buffer([0xFF, 0xCA, 0x00, 0x00, 0x00]), 40, protocol, function(err, data) {
					console.log(data);
					//console.log(data.toString('ascii'));
					console.log(data.toString('hex'));
					//console.log(JSON.stringify(data));
					eventEngine.emit('passed', data.toString('hex'));
				});
			});
		}
	});
});

var brig = new Brig();

brig.on('ready', function(brig) {
	brig.open('opencard.qml', function(err, window) {

		eventEngine.on('passed', function(token) {

			var regno = window.getProperty('regNo');
			var cardno = window.getProperty('cardNo');
			if (!regno || !cardno)
				return;

			// Connect to server to initialize card
			http.get({
				host: '104.236.253.189',
				port: 80,
				path: '/opencard/' + regno + '/' + cardno + '/' + token
			}, function(res) {

				var data = [];
				res.on('data', function(chunk) {
					data.push(chuck.toString());
				});

				res.on('end', function() {
					console.log(data.join(''));
					window.emit('passed');
				});
			});
		});
	});
});
