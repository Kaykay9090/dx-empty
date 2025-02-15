import { LightningElement} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import docxLibs from '@salesforce/resourceUrl/docxLibs';
//import getAccountData from '@salesforce/apex/AccountController.getAccountData';
//import uploadDocxToAccount from '@salesforce/apex/AccountController.uploadDocxToAccount';

export default class GenerateSuitabilityDocument extends LightningElement {
    // initiate Properties 
    docxtemplaterLoaded = false;

    // load resources 
    renderedCallback() {
        if (this.docxtemplaterLoaded) {
            return;
        }

        Promise.all([
            loadScript(this, docxLibs+'docxtemplater/docxtemplater.min.js'),
            loadScript(this, docxLibs+'pizzip/pizzip.min.js')
        ]).then(() => {
            this.docxtemplaterLoaded = true;
        }).catch(error => {
            console.error('Error loading scripts: ', error);
        });
    }

    // get relevant placeholder infromation

    // get referance document from static

    // generate document 
    generateDoc(){
        const templateUrl = '/resource/SuitabilityReport.docx';
        fetch(templateUrl)
            .then(res => res.arrayBuffer())
            .then(content => {
                const zip = new pizzipLib(content);
                const doc = new window.docxtemplater().loadZip(zip);
                doc.setData({
                    date: "2024/08/11",
                    title: "Mr."
                    // Add more fields as needed
                });

                try {
                    doc.render();
                } catch (error) {
                    console.error('Error rendering document: ', error);
                    return;
                }

                const out = doc.getZip().generate({
                    type: 'blob',
                    mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                });

                // Convert Blob to base64
                const reader = new FileReader();
                reader.onloadend = () => {
                    const base64data = reader.result.split(',')[1];
                    this.uploadDocx(base64data);
                };
                reader.readAsDataURL(out);
            });
    }

    

    // uploadDocx(base64Data) {
       
    // }

}