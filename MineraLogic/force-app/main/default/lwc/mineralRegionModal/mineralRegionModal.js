import { LightningElement, api } from 'lwc';

export default class MineralRegionModal extends LightningElement {
	isCreateMineralOpen = false;
	latitude = '';
	longitude = '';
	title = '';
	description = '';

	@api displayModal() {
		this.isCreateMineralOpen = true;
	}

	@api handleCancel() {
		this.isCreateMineralOpen = false;
	}

	handleSave() {
		this.updateRegionOfInterest();
		this.handleCancel();
	}

	latitudeChange(event) {
		if(event.target.name === "Latitude") {
			this.latitude = event.target.value;
		}
	}

	longitudeChange(event) {
		if(event.target.name === "Longitude") {
			this.longitude = event.target.value;
		}
	}

	titleChange(event) {
		if(event.target.name === "Title") {
			this.title = event.target.value;
		}
	}

	descriptionChange(event) {
		if(event.target.name === "Description") {
			this.description = event.target.value;
		}
	}

	updateRegionOfInterest(){
		this.dispatchEvent(new CustomEvent('regionchanged', {
			detail: {
				latitude: this.latitude,
				longitude: this.longitude,
				title: this.title,
				description: this.description
			}
		}));
	}

}