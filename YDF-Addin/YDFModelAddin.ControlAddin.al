controladdin YDFModelAddin
{
    // invisible addin as we only want to run js functions
    MaximumHeight = 1;
    MaximumWidth = 1;
    MinimumHeight = 0;
    MinimumWidth = 0;
    RequestedHeight = 0;
    RequestedWidth = 0;

    // This startup script file contain ydf-inferecnce, ydf-training, and jszip.min.js
    // At the end the event trigger AddinReady, indicate to BC the javascript is loaded and functions can be used.
    // Using startup script make sure all scripts function are available in other script
    // YDF inference : https://www.jsdelivr.com/package/npm/ydf-inference
    // YDF training : https://www.jsdelivr.com/package/npm/ydf-training
    StartupScript = 'YDF-Addin/YDFModelAddinForBC.Startup.js';

    // Addin script in wich we can use bellow functions
    Scripts = 'YDF-Addin/YDFModelAddinForBC.js';


    // The procedure declarations specify what JavaScript methods could be called from AL.
    procedure TestSampleModel(); // This is just a basic test using google data sample to create, train and run a small model. Result are shown in browser console.
    procedure LoadModel(ModelID: Integer; Base64ModelFileContent: Text);   // This just passe a model file to the javascript to load it and return geenral information in bellow trigger
    procedure RunModel(ModelID: Integer; JsonInputs: Text); // This passe a model file to the javascript to load and run it using JsonInputs. Result are then triggered in RunModelSuceed or RunModelFailed
    procedure TrainModel(ComaSeparatedDataWithHeader: Text; OutputColumnLabel: Text); // Create and traina  model given input data, formated as csv file coma separated and with one header row indicating the name of columns, and the name of column the output shall be learned to.


    // The event declarations specify what callbacks could be raised from JavaScript by using the webclient API:
    // Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CallBack', [42, 'some text', 5.8, 'c'])
    event AddinReady();
    event TestSuceed(Base64ModelFileContent: Text); // Triggered when the TestSampleModel() is completed and retrieve the demo trained model file data as base64 text
    event TestFailed(ErrorMessage: Text); // Triggered when the TestSampleModel() is failed. Result are shown in browser console.
    event TrainModelSuceed(Base64ModelFileContent: Text); // Triggerred when a model training ended sucessfully and retrieve the model file data as base64 text
    event TrainModelFailed(ErrorMessage: Text); // Triggerred when a model training failed and give the javascript error message
    event LoadModelFailed(ModelID: Integer; ErrorMessage: Text); // Error message if the model could not be loaded using YDF (triggered by LoadModel).
    event LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text); // (triggered by LoadModel) Each variable are separated by a comma and the number of element is the same for each variable.
    event RunModelSuceed(ModelID: Integer; Result: Text); // (triggered by LoadModel) Result is the prediction result of the model, each value is separated by a comma.
    event RunModelFailed(ModelID: Integer; ErrorMessage: Text); // (triggered by LoadModel) Error message if the model could not be runned using YDF (triggered by LoadModel).
}