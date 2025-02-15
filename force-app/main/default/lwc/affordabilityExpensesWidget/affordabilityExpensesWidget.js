import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';  
import { refreshApex } from '@salesforce/apex';
import getTotalAffordabilityExpense from '@salesforce/apex/AffordabilityController.getTotalAffordabilityExpense';
import getAffordabilityRecords from '@salesforce/apex/AffordabilityController.getAffordabilityRecords';
import updateMortgageCase from '@salesforce/apex/AffordabilityController.updateMortgageCase';

export default class AffordabilityAccordion extends LightningElement {
    @api recordId;
    @track mortgageCaseRecord = [];
    totalAffordabilityExpense = 0;
    affordabilityRecords = [];
    householdExp = 0.0; livingExp = 0.0; lifestyleExp = 0.0; transportExp = 0.0; childrenExp = 0.0; expenditureExp = 0.0;
    @track lastRefreshed = new Date().toLocaleString();
    @track showModal = false;
    @track showNegativeButton = true;
    @track showPositiveButton = true;
    @track positiveButtonLabel = 'Save';
    @track negativeButtonLabel = 'Close';
    @track header = '';
    @track bodyContent = '';
    @track accText = '';
    @api triggeredRecord = [];
    @track hasAffordabilityRecords = false;

    closeModal() {
        this.showModal = false;
    }

    showModalPopup(event) {
        const section = event.target.getAttribute('data-section'); 
        console.log("CATEGORY SELECTED >> ", section);
    
        if (!this.mortgageCaseRecord || this.mortgageCaseRecord.length === 0) {
            getTotalAffordabilityExpense({ mortgageCaseId: this.recordId })
                .then(data => {
                    this.mortgageCaseRecord = data;
                    this.assignTriggeredRecord(section);
                    this.showModal = true;
                })
                .catch(error => {
                    console.error('Failed to load mortgage case record:', error);
                    this.showToast('Error', 'Failed to load mortgage case record.', 'error');
                });
        } else {
            this.assignTriggeredRecord(section);
            this.showModal = true;
        }
    }
    
    assignTriggeredRecord(section) {
        this.triggeredRecord = this.mortgageCaseRecord;
        console.log("triggeredRecord p : ",JSON.stringify(this.triggeredRecord, null, 2));
    
        switch(section) {
            case 'household':
                this.header = 'Household Summary';
                this.bodyContent = this.householdExp;
                break;
            case 'living':
                this.header = 'Living Summary';
                this.bodyContent = this.livingExp;
                break;
            case 'lifestyle':
                this.header = 'Lifestyle Summary';
                this.bodyContent = this.lifestyleExp;
                break;
            case 'transport':
                this.header = 'Transport Summary';
                this.bodyContent = this.transportExp;
                break;
            case 'children':
                this.header = 'Children Summary';
                this.bodyContent = this.childrenExp;
                break;
            case 'expenditure':
                this.header = 'Expenditure Summary';
                this.bodyContent = this.expenditureExp;
                break;
            default:
                this.header = 'Details';
                this.bodyContent = 'Details about the selected section.';
        }
    }      
    

    wiredTotalExpenseResult;
    wiredAffordabilityRecordsResult;

    @wire(getTotalAffordabilityExpense, { mortgageCaseId: '$recordId' })
    wiredTotalExpense(result) {
        this.wiredTotalExpenseResult = result; // Store the wired result
        const { data, error } = result;
        if (data) {
            this.totalAffordabilityExpense = (data.Household_Expenses__c !== undefined && data.Household_Expenses__c !== null ? Number(data.Household_Expenses__c) : 0) +
                                     (data.Living_Expenses__c !== undefined && data.Living_Expenses__c !== null ? Number(data.Living_Expenses__c) : 0) +
                                     (data.Lifestyle_Expenses__c !== undefined && data.Lifestyle_Expenses__c !== null ? Number(data.Lifestyle_Expenses__c) : 0) +
                                     (data.Transport_Expenses__c !== undefined && data.Transport_Expenses__c !== null ? Number(data.Transport_Expenses__c) : 0) +
                                     (data.Children_Expenses__c !== undefined && data.Children_Expenses__c !== null ? Number(data.Children_Expenses__c) : 0) +
                                     (data.Expenditure_Expenses__c !== undefined && data.Expenditure_Expenses__c !== null ? Number(data.Expenditure_Expenses__c) : 0);
            console.log("TOTAL EXPENSES : ", this.totalAffordabilityExpense);
            console.log("MORTGAGE CASE RECORD >> ", data);
            
            this.mortgageCaseRecord = data;
            this.householdExp = data.Household_Expenses__c !== undefined && data.Household_Expenses__c !== null ? Number(data.Household_Expenses__c) : 0;
            this.livingExp = data.Living_Expenses__c !== undefined && data.Living_Expenses__c !== null ? Number(data.Living_Expenses__c) : 0;
            this.lifestyleExp = data.Lifestyle_Expenses__c !== undefined && data.Lifestyle_Expenses__c !== null ? Number(data.Lifestyle_Expenses__c) : 0;
            this.transportExp = data.Transport_Expenses__c !== undefined && data.Transport_Expenses__c !== null ? Number(data.Transport_Expenses__c) : 0;
            this.childrenExp = data.Children_Expenses__c !== undefined && data.Children_Expenses__c !== null ? Number(data.Children_Expenses__c) : 0;
            this.expenditureExp = data.Expenditure_Expenses__c !== undefined && data.Expenditure_Expenses__c !== null ? Number(data.Expenditure_Expenses__c) : 0;
        } else if (error) {
            console.error('Failed to load total affordability expense:', error);
        }
    }

    // Fetch related Affordability records
    @wire(getAffordabilityRecords, { mortgageCaseId: '$recordId' })
    wiredAffordabilityRecords(result) {
        this.wiredAffordabilityRecordsResult = result; // Store the wired result
        const { data, error } = result;
        if (data && data.length > 0) {
            console.log("AFFORDABILITY RECORDS : ", data);
            this.affordabilityRecords = data;
            this.hasAffordabilityRecords = true;
            console.log(this.hasAffordabilityRecords)
        } else if (error) {
            console.error(error);
            // this.showToast('Error', 'Failed to load affordability records.', 'error');
            this.hasAffordabilityRecords = false;
        }
    }   


    get householdLabel() {
        const mortgageRent = this.mortgageCaseRecord.Mortgage_Rent_Sum__c || 0;
        const councilTax = this.mortgageCaseRecord.Council_Tax_Sum__c || 0;
        const utilities = this.mortgageCaseRecord.Utilities_Sum__c || 0;

        this.householdExp = Number(mortgageRent) + Number(councilTax) + Number(utilities);
        
        if (isNaN(this.householdExp) || this.householdExp === 0) {
            return `Household Expenses - £0.00`;
        } else {
            return `Household Expenses - £${this.householdExp.toFixed(2)}`;
        }
    }

    get livingLabel() {
        const clothing = this.mortgageCaseRecord.Clothing_Sum__c || 0;
        const groceries = this.mortgageCaseRecord.Groceries_Sum__c || 0;
        const tvInternetCommunication = this.mortgageCaseRecord.TV_Internet_Communication_Sum__c || 0;
    
        this.livingExp = Number(clothing) + Number(groceries) + Number(tvInternetCommunication);
    
        if (isNaN(this.livingExp) || this.livingExp === 0) {
            return `Living Expenses - £0.00`;
        } else {
            return `Living Expenses - £${this.livingExp.toFixed(2)}`;
        }
    }    

    get lifestyleLabel() {
        const leisure = this.mortgageCaseRecord.Leisure_Sum__c || 0;
        const entertainment = this.mortgageCaseRecord.Entertainment_Sum__c || 0;
        const gambling = this.mortgageCaseRecord.Gambling_Sum__c || 0;
        const insurances = this.mortgageCaseRecord.Insurances_Sum__c || 0;
        const investments = this.mortgageCaseRecord.Investments_Sum__c || 0;
        const sports = this.mortgageCaseRecord.Sports_Sum__c || 0;
        const travel = this.mortgageCaseRecord.Travel_Sum__c || 0;
    
        this.lifestyleExp = Number(leisure) + Number(entertainment) + Number(gambling) + Number(insurances) + Number(investments) + Number(sports) + Number(travel);
    
        if (isNaN(this.lifestyleExp) || this.lifestyleExp === 0) {
            return `Lifestyle Expenses - £0.00`;
        } else {
            return `Lifestyle Expenses - £${this.lifestyleExp.toFixed(2)}`;
        }
    }    

    get transportLabel() {
        this.transportExp = this.mortgageCaseRecord.Transport_Travel_Sum__c;
        if (this.transportExp === null || this.transportExp === '' || this.transportExp === undefined) {
            return `Transport Expenses - £0.00`;
        }else{
            return `Transport Expenses - £${this.transportExp.toFixed(2)}`;
        }        
    }

    get childrenLabel() {        
        this.childrenExp = this.mortgageCaseRecord.Schooling_Sum__c;
        if (this.childrenExp === null || this.childrenExp === '' || this.childrenExp === undefined) {
            return `Children Expenses - £0.00`;
        }else {
            return `Children Expenses - £${this.childrenExp.toFixed(2)}`;
        }   
    }

    get expenditureLabel() {
        return `Expenditure Expenses - £${this.expenditureExp.toFixed(2)}`;
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
    
        const updatedRecord = {
          Id: this.affordabilityRecords[0].Mortgage_Case__c,
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

        updateMortgageCase({ record: updatedRecord })
            .then(() => {
                this.showToast('Success', 'Affordability records updated successfully.', 'success');
                // Refresh the component after save
                return Promise.all([
                    refreshApex(this.wiredTotalExpenseResult),
                    refreshApex(this.wiredAffordabilityRecordsResult)
                ]);
            })
            .catch(error => {
                this.showToast('Error', 'Failed to update affordability records: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}