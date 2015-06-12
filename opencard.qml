import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ApplicationWindow {
	width: 800;
	height: 600;
	color: 'black';
	visible: true;

	property int regNo: 0;
	property int cardNo: 0;

	signal passed();

	onPassed: {
		cardDetector.visible = false;
		console.log('PASSED');
		statusText.visible = true;
		statusText.text = 'Opened!'
		statusText.opacity = 1.0;
		statusText.scale = 1.0;
	}

	function restart() {
		statusText.visible = false;
		cardDetector.visible = false;
		cardnoModal.visible = false;
		regnoModal.visible = true;
		input.text = '';
		cardno.text = '';
		regNo = 0;
		cardNo = 0;
	}

	Image {
		anchors.top: parent.top;
		anchors.right: parent.right;
		anchors.margins: 20;
		width: parent.width * 0.2;
		height: parent.height * 0.2;
		source: './hackathontw.png'
		fillMode: Image.PreserveAspectFit;
		asynchronous: true;
		cache: true;
		smooth: true;
	}

	Rectangle {
		id: cardDetector;
		anchors.centerIn: parent;
		width: parent.width * 0.7;
		height: parent.height * 0.4;
		color: '#22ffcccc';
		radius: 10;
		visible: false;
		focus: !cardnoModal.visible && !regnoModal.visible;

		Text {
			anchors.centerIn: parent;
			text: 'Please Insert Blank Card';
			font.family: 'Helvetica';
			font.bold: true;
			font.pointSize: 36;
			color: '#ff5555';
		}

		Keys.onEscapePressed: restart();
		Keys.onReturnPressed: {
			cardDetector.visible = false;
			passed();
		}
	}

	Rectangle {
		id: regnoModal;
		anchors.centerIn: parent;
		width: parent.width * 0.5;
		height: parent.height * 0.2;
		color: '#33ffffff';
		radius: 20;

		Text {
			anchors.bottom: input.top;
			anchors.horizontalCenter: input.horizontalCenter;
			anchors.bottomMargin: 20;
			text: 'Please Enter Registration Number';
			font.family: 'Helvetica';
			font.bold: true;
			font.pointSize: 24;
			color: '#00ffcc';
		}

		TextInput {
			id: input;
			anchors.fill: parent;
			font.family: 'Helvetica';
			font.bold: true;
			font.pointSize: 62;
			color: '#ffffff';
			focus: regnoModal.visible;
			validator: IntValidator{
				bottom: 0;
				top: 999;
			}
			horizontalAlignment: TextInput.AlignHCenter;
			verticalAlignment: TextInput.AlignVCenter;
		}

		Keys.onReturnPressed: {
			console.log(input.text);
			regNo = input.text;
			if (input.text == '')
				return;

			input.text = '';
			regnoModal.visible = false;
			cardnoModal.visible = true;
		}

		Keys.onEscapePressed: restart();
	}

	Rectangle {
		id: cardnoModal;
		anchors.centerIn: parent;
		width: parent.width * 0.5;
		height: parent.height * 0.2;
		color: '#33ffffff';
		radius: 20;
		visible: false;

		Text {
			anchors.bottom: cardno.top;
			anchors.horizontalCenter: cardno.horizontalCenter;
			anchors.bottomMargin: 20;
			text: 'Enter Blank Card Number';
			font.family: 'Helvetica';
			font.bold: true;
			font.pointSize: 24;
			color: '#00ccff';
		}

		TextInput {
			id: cardno;
			anchors.fill: parent;
			font.family: 'Helvetica';
			font.bold: true;
			font.pointSize: 62;
			color: '#ffffff';
			focus: cardnoModal.visible;
			validator: IntValidator{
				bottom: 0;
				top: 999;
			}
			horizontalAlignment: TextInput.AlignHCenter;
			verticalAlignment: TextInput.AlignVCenter;
		}

		Keys.onReturnPressed: {
			console.log(cardno.text);
			cardNo = cardno.text;
			if (cardno.text == '')
				return;

			cardno.text = '';
			cardnoModal.visible = false;
			cardDetector.visible = true;
		}

		Keys.onEscapePressed: restart();
	}

	Text {
		id: statusText;
		anchors.centerIn: parent;
		text: 'Brig';
		font.family: 'Helvetica';
		font.bold: true;
		font.pointSize: 72;
		color: '#00ffcc';
		scale: 0;
		opacity: 0;
		visible: false;
		focus: statusText.visible;

		Keys.onPressed: {
			restart();
		}

		Text {
			anchors.topMargin: 10;
			anchors.top: parent.bottom; 
			anchors.horizontalCenter: parent.horizontalCenter;
			text: 'Press any keys to continue';
			font.family: 'Helvetica';
			font.pointSize: 16;
			color: '#e6fffa';
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 800;
				easing.type: Easing.OutCubic;
			}
		}

		Behavior on scale {
			NumberAnimation {
				duration: 1000;
				easing.type: Easing.OutBack;
			}
		}
	}
}
