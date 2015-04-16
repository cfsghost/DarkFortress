import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ApplicationWindow {
	width: 800;
	height: 600;
	color: 'black';
	visible: true;

	signal passed();

	onPassed: {
		console.log('PASSED');
		statusText.text = 'PASSED!';
		statusText.opacity = 1.0;
		statusText.scale = 1.0;
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

		Text {
			anchors.topMargin: 10;
			anchors.top: parent.bottom; 
			anchors.horizontalCenter: parent.horizontalCenter;
			text: 'QML Application in Node.js';
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
