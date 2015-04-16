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
					eventEngine.emit('passed');
				});
			});
		}
	});
});

var brig = new Brig();

brig.on('ready', function(brig) {
	brig.open('application.qml', function(err, window) {
/*
		window.on('heartBeated', function() {
			console.log('Listener in Node.js Scope');
		});

		setInterval(function() {
			window.emit('heartBeated');
		}, 1000);

		setTimeout(function() {
			var timestamp = Date.now();
			console.log('Correct data: ', timestamp, 'Hello', 123);
			window.emit('touched', timestamp, 'Hello', 123);
			window.emit('testInt', 99, 100);
			window.emit('testVariant', 'Variant String');
		}, 1000);
*/
		eventEngine.on('passed', function() {
			window.emit('passed');
		});
	});
});
