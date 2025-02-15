import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import getTotalAffordabilityExpense from '@salesforce/apex/AffordabilityController.getTotalAffordabilityExpense';
import updateMortgageCase from '@salesforce/apex/AffordabilityController.updateMortgageCase';

export default class UtilModal extends LightningElement {
  @api showPositive;
  @api showNegative;
  @api positiveButtonLabel = 'Save';
  @api negativeButtonLabel = 'Cancel';
  @api showModal;
  @api header;
  @api bodyContent;
  @api mortgageCaseRecord = '';
  @api triggeredRecord ;
  @api temp = [];
  @api affordabilityRecords = [];
  @track fieldApiNames = [];
  @track fieldLabels = [];
  mortgageRent = 0.0; councilTax = 0.0; utilities = 0.0; clothing = 0.0; groceries = 0.0; leisure = 0.0; entertainment = 0.0; gambling = 0.0; insurances = 0.0; sports = 0.0; travel = 0.0; transportTravel = 0.0; schooling = 0.0; @api tvintcomm = 0.0; @api investments = 0.0; 

  constructor() {
    super();
    this.showNegative = true;
    this.showPositive = true;
    this.showModal = false;
  }

  renderedCallback() {

    console.log("triggeredRecord c : ",JSON.stringify(this.triggeredRecord, null, 2));
    

    // switch(this.header) {
    //   case 'Household Summary':
    //       this.fieldApiNames = ['Mortgage_rent__c','Council_Tax__c','Utilities__c'];
    //       this.fieldLabels = ['Mortgage Rent','Council Tax','Utilities'];
    //       break;
    //   case 'Living Summary':
    //       this.fieldApiNames = ['Clothing__c','Groceries__c','TV_internet_communication__c'];
    //       this.fieldLabels = ['Clothing','Groceries','TV/Internet Communication'];
    //       break;
    //   case 'Lifestyle Summary':
    //       this.fieldApiNames = ['Leisure__c','Entertainment__c','Gambling__c','Insurances__c','Investments__c','Sports__c','Travel__c'];
    //       this.fieldLabels = ['Leisure','Entertainment','Gambling','Insurances','Investments','Sports','Travel'];
    //       break;
    //   case 'Transport Summary':
    //       this.fieldApiNames = ['Transport_travel__c'];
    //       this.fieldLabels = ['Transport Travel'];
    //       break;
    //   case 'Children Summary':
    //       this.fieldApiNames = ['Schooling__c'];
    //       this.fieldLabels = ['Schooling'];
    //       break;
    //   case 'Expenditure Summary':
    //       this.fieldApiNames = [];
    //       this.fieldLabels = [];
    //       break;
    //   default:
    //       this.fieldApiNames = 'Details';
    //       this.fieldLabels = 'Details';
    // }    
  }



  get hasNoFields() {
    return this.fieldLabels.length === 0;
  }

  handleSave() {
    const mortgageRentInput = this.template.querySelector('[data-id="mortgageRent"]').value;
    const councilTaxInput = this.template.querySelector('[data-id="councilTax"]').value;
    const utilitiesInput = this.template.querySelector('[data-id="utilities"]').value;
    const clothingInput = this.template.querySelector('[data-id="clothing"]').value;
    const groceriesInput = this.template.querySelector('[data-id="groceries"]').value;
    const tvintcommInput = this.template.querySelector('[data-id="tvinternetcomm"]').value;
    const leisureInput = this.template.querySelector('[data-id="leisure"]').value;
    const entertainmentInput = this.template.querySelector('[data-id="entertainment"]').value;
    const gamblingInput = this.template.querySelector('[data-id="gambling"]').value;
    const insurancesInput = this.template.querySelector('[data-id="insurances"]').value;
    const investmentsInput = this.template.querySelector('[data-id="investments"]').value;
    const sportsInput = this.template.querySelector('[data-id="sports"]').value;
    const travelInput = this.template.querySelector('[data-id="travel"]').value;
    const transportravelInput = this.template.querySelector('[data-id="transporttravel"]').value;
    const schoolingInput = this.template.querySelector('[data-id="schooling"]').value;

    console.log('0: ',this.affordabilityRecords[0].Mortgage_Case__c,' , 1: ',mortgageRentInput,' , 2: ',councilTaxInput,' , 3: ',utilitiesInput);

    const updatedRecord = {
      Id: this.affordabilityRecords[0].Mortgage_Case__c,
      Name: this.affordabilityRecords[0].Name,
      Mortgage_Rent_Sum__c: mortgageRentInput || null,
      Council_Tax_Sum__c: councilTaxInput || null,
      Utilities_Sum__c: utilitiesInput || null,
      Clothing_Sum__c: clothingInput || null,
      Groceries_Sum__c: groceriesInput || null,
      TV_Internet_Communication_Sum__c: tvintcommInput || null,
      Leisure_Sum__c: leisureInput || null,
      Entertainment_Sum__c: entertainmentInput || null,
      Gambling_Sum__c: gamblingInput || null,
      Insurances_Sum__c: insurancesInput || null,
      Investments_Sum__c: investmentsInput || null,
      Sports_Sum__c: sportsInput || null,
      Travel_Sum__c: travelInput || null,
      Transport_Travel_Sum__c: transportravelInput || null,
      Schooling_Sum__c: schoolingInput || null
    };
    
    if (this.validateInputs(mortgageRentInput, councilTaxInput, utilitiesInput)) {
      updateMortgageCase({ record: updatedRecord })
          .then(() => {
              this.showToast('Success', 'Affordability records updated successfully.', 'success');
              this.closeModal();
          })
          .catch(error => {
              this.showToast('Error', 'Failed to update affordability records: ' + error.body.message, 'error');
          });
    } else {
        this.showToast('Error', 'Please fill in all required fields.', 'error');
    }
  }

  validateInputs(mortgageRentInput, councilTaxInput, utilitiesInput) {
    return mortgageRentInput && councilTaxInput && utilitiesInput;
  }

  showToast(title, message, variant) {
      const event = new ShowToastEvent({
          title: title,
          message: message,
          variant: variant
      });
      this.dispatchEvent(event);
  }

  handlePositive() {
      this.handleSave(); 
  }
  
  handleNegative() {
    this.dispatchEvent(new CustomEvent('negative'));
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent('close'));
  }
}