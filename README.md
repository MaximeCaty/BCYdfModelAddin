This example show how to create a control addin to train and run YDF AI Model in Business Central.
Model functions are runned in javascript using client browser so it is not possible to use thoses function in job queue or web services.
The extension let you manage models in a table, store inputs and labels, train it from Busienss central data and run model with user inputs. 
You can also upload existing model created outside of BC, as the library accept tensorflow seved model format.

Learn more about Google Yggdrasil Decision Forest library here : 
https://ydf.readthedocs.io/en/stable/

Javascript implementation : 
https://ydf.readthedocs.io/en/stable/javascript/

Test it using google sheet data : 
https://workspace.google.com/marketplace/app/simple_ml_for_sheets/685936641092?hl=fr

The controladdin "YDFModelAddin" provide you bellow function :

- TestSampleModel()
- LoadModel(ModelID: Integer; Base64ModelFileContent: Text)
- RunModel(ModelID: Integer; JsonInputs: Text)
- TrainModel(ComaSeparatedDataWithHeader: Text; FeaturesSemantic: Text; OutputColumnLabel: Text)

And triggers :

- AddinReady();
- TestSuceed(Base64ModelFileContent: Text); 
- TestFailed(ErrorMessage: Text); 
- TrainModelSuceed(Base64ModelFileContent: Text);
- TrainModelFailed(ErrorMessage: Text); 
- LoadModelFailed(ModelID: Integer; ErrorMessage: Text);
- LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text); // (triggered by LoadModel) Each variable are separated by a comma and the number of element is the same for each variable.
- RunModelSuceed(ModelID: Integer; Result: Text);
- RunModelFailed(ModelID: Integer; ErrorMessage: Text);

Exemple - Implement a model to run suggesiton on an existing page

###### Add the addin to a page ####

```
usercontrol(YDFAddin; YDFModelAddin)
{
    trigger AddinReady()
    var
      Model: Record "";
    begin
        // Load an AI Model
        Model.Get(1);
        CurrPage.YDFAddin.LoadModel(Model.ID, Model.GetModelContentAsB64Text()); // pass the model file to javascript
    end;

    trigger LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text)
    begin
        ModelLoaded := true; // you can use this boolean to prevent model running when it is not loaded yet
    end;

    trigger LoadModelFailed(ModelID: Integer; ErrorMessage: Text)
    begin
        Error(ErrorMessage);
    end;

    trigger RunModelSuceed(ModelID: Integer; Result: Text)
    var
        Confidence: Integer;
    begin
        OutPutResult := Rec.DecodeOutputBestValue(Result, Confidence); // handle model prediction
    end;

    trigger RunModelFailed(ModelID: Integer; ErrorMessage: Text)
    begin
        Error(ErrorMessage);
    end;
}
```


###### Run the model ######

Use bellow code to run model prediction based on your own input data

```
var
  JsonInputs: Text;
begin
  JsonInputs := '{"Country Code": "US", "City": "Buffalo"}'; // Input must be encoded in json text. You can get inputs name from record "YDF Model Input Features"
  CurrPage.YDFAddin.RunModel(1, JsonInputs);
end;
```

###### Handle Result ######

As javascript run a-synchronooius of AL, you need to handle the model prediction result in the usercontrol trigger as bellow.
This function return raw model result, and you can use a premade function to map it with proper label and get the model condifence.

```
trigger RunModelSuceed(ModelID: Integer; Result: Text)
var
    Confidence: Integer;
begin
    OutPutResult := Rec.DecodeOutputBestValue(Result, Confidence);
    // Affect the predicted value to something in Business Central :
    if (Confidence > 50) then begin
        Rec."Gen. Bus. Posting Group" := OutputResult;
        Rec.Modify();
    end;
end;
```
