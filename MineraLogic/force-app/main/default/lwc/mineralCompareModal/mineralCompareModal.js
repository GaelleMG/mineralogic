import { LightningElement, api } from 'lwc';

export default class MineralCompareModal extends LightningElement {
    isCompareMineralOpen = false;
    @api mapMarkers;

    @api displayModal() {
		this.isCompareMineralOpen = true;
	}

	@api handleCancel() {
		this.isCompareMineralOpen = false;
	}

    handleSave() {
        this.handleCancel();
    }

    titleChange(event) {
        // TODO: Implement the comparison of different regions
    }
}