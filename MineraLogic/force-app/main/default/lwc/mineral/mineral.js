import { LightningElement, track } from 'lwc';
import { labels } from './mineralHelper.js';
import getLocations from '@salesforce/apex/Mineral.getLocationInformation';

const LATITUDE = '1.6596';
const LONGITUDE = '28.0339';

export default class Mineral extends LightningElement {
	@track mapMarkers = [];
	listView = 'visible';
	selectedMarkerValue = 'Min1';
	error;
	labels = labels;

	connectedCallback() {
		getLocations()
		.then( result => {
			const constLocation = [];
			result.forEach((location) => {
				const loc = {
					location: { Latitude: location.latitude, Longitude: location.longitude},
					title: location.title,
					value: location.value,
					description: 'Hello World'
				}
				constLocation.push(JSON.parse(JSON.stringify(loc)));
			});
			this.mapMarkers = constLocation;
		}).catch( error => {
			this.error = error;
		});
	}

	center = {
		location: { Latitude: LATITUDE, Longitude: LONGITUDE },
	};

	handleMarkerSelect(event) {
		this.selectedMarkerValue = event.target.selectedMarkerValue;
	}

	addRegion() {
		this.template.querySelector('c-mineral-region-modal').displayModal();
	}

	updateRegionView(event) {
		const constLocation = [];
		const loc = {
			location: {
				Latitude: event.detail.latitude,
				Longitude: event.detail.longitude
			},
			title: event.detail.title,
			value: ''
		}
		constLocation.push(JSON.parse(JSON.stringify(loc)));
		this.mapMarkers = [...this.mapMarkers, ...constLocation]
	}
}
