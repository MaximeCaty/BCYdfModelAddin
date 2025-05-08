This example show how to use a control addin to train and run YDF AI Model in Business Central.

The model is runned in javascript in client browser, so it is not possible to use thoses function in job queue or web services.

The extension let you store models in a table with associated inputs and labels, train new model from Busienss central data and test a model with user inputs. 

You can also upload existing model created outside of BC, as the library accept tensorflow "SavedModel" format (zip file containing .pb data).

Learn more about Google Yggdrasil Decision Forest library here : 
https://ydf.readthedocs.io/en/stable/

Javascript implementation : 
https://ydf.readthedocs.io/en/stable/javascript/

Play with it with excel dataset/google sheet :
https://workspace.google.com/marketplace/app/simple_ml_for_sheets/685936641092?hl=fr

Exemple - Implement a model to run suggestion on an existing page

###### Add the usercontrol on a page ####

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

###### Load a model #####

Wait the javascript to be loaded (trigger AddinReady) so you can load a model in browser memory.
You can pass model file as base 64 text to the js function as I did not find a way to pass stream (wich would be more efficient)


```
    trigger AddinReady()
    var
      Model: Record "";
    begin
        Model.Get(1);  // get a model stored in Business central
        CurrPage.YDFAddin.LoadModel(Model.ID, Model.GetModelContentAsB64Text()); // pass the model file to javascript as base 64 encoded text
    end;
```

###### Run the model ######

Use bellow code to run model prediction based on your own input data
Inputs shall be encoded as JSON
For texte input, the value shall be splited by word (using space as split) to an array as the model use each words separatly to match his dictionnary and run the prediction.

```
var
  JsonInputs: Text;
begin
  JsonInputs := '{"Country Code": "US", "City": "Buffalo"}'; // Input must be encoded in json text. You can get inputs name from record "YDF Model Input Features"
  CurrPage.YDFAddin.RunModel(1, JsonInputs);
end;
```

###### Handle Result ######

As javascript run asynchronous of AL code, you need to handle the model prediction in usercontrol trigger.

This trigger get the model raw result, you can use function to retrieve the proper text matching prediction with confidence percentage.


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
