var YDFmodels = []; // Globally accessible in browsers
var YDFInf = null;

// Basic model testing function
// 1.Download training dataset
// 2.Train a model
// 3.Run the model with different inputs, and show result in console
// 4.Trigger test suceed or failed accordingly
async function TestSampleModel() {
  try {
      console.log("Creating a model training...");

      ydf = await YDFTraining();

      console.log("Downloading dataset sample (2.5Mb)...");

      // dataset sample are provided by google under License Apache-2.0
      dataset = await fetch("https://raw.githubusercontent.com/google/yggdrasil-decision-forests/main/yggdrasil_decision_forests/test_data/dataset/adult_train.csv");
      const data = await dataset.text()

      console.log("Download completed, creating and training the AI model...");

      task = "CLASSIFICATION";
      label = "income";

      model = new ydf.GradientBoostedTreesLearner(label, task).train(data);

      console.log("Training completed model details : ");
      console.log(model);

      // Create one input to run the model on
      let examples = {
          "age": [39],
          "workclass": ["State-gov"],
          "fnlwgt": [77516],
          "education": ["Bachelors"],
          "education_num": ["13"],
          "marital_status": ["Never-married"],
          "occupation": ["Adm-clerical"],
          "relationship": ["Not-in-family"],
          "race": ["White"],
          "sex": ["Male"],
          "capital_gain": [2174],
          "capital_loss": [0],
          "hours_per_week": [40],
          "native_country": ["United-States"]
      };

      // run the model
      console.log("Running model on different inputs...");
      predictions = model.predict(examples);

      console.log("RUNNING MODEL RESULTS : ");
      console.log(predictions);
      
      modelAsZipBlob = await model.save();
      Base64ModelFileContent = await blobToBase64(modelAsZipBlob);
      model.unload();
      
      console.log("!! Congrats, YDF sample model test run sucessfully !!")

      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("TestSuceed", [Base64ModelFileContent], !1);
    }
    catch(err) {
      console.log("YDF sample model test failed :(");
      console.log(err.message);
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("TestFailed", [err.message], !1);
    }
}

async function TrainModel(ComaSeparatedDataWithHeader, OutputColumnLabel) {
  try {
    console.log("Creating a model training...");

    ydfTrainer = await YDFTraining();

    task = "CLASSIFICATION";
    label = OutputColumnLabel;

    // Documentation for the learner :
    // https://ydf.readthedocs.io/en/stable/py_api/GradientBoostedTreesLearner/
    // Unfortunatly javascript wrapper does not support hyperparameter such as feature details to configure how data are used by the model
    // So alway keep default configuration for the learner :
    // Text : min vocabulary = 5, max = 2000, semantic alway CATEGORICAL_SET when the column have space
    // Convert to an array of JavaScript objects
    model = new ydfTrainer.GradientBoostedTreesLearner(label, task).train(ComaSeparatedDataWithHeader);

    console.log("Training completed model:");
    console.log(model);

    ModelAsZipBlob = await model.save();
    Base64ModelFileContent = await blobToBase64(ModelAsZipBlob);

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("TrainModelSuceed", [Base64ModelFileContent], !1);
  }
  catch(err) {
    console.log("YDF sample model test failed :");
    console.log(err.message);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("TrainModelFailed", [err.message], !1);
  }
}

// Load a model and return informations to BC such as inputs and labels
async function LoadModel(ModelID, Base64ModelFileContent) {
  // Convert base64 to blob
  try {
    const byteCharacters = atob(Base64ModelFileContent);

    // Load the model with YDF inference
    if (YDFInf == null) {
      YDFInf = await YDFInference()
    }
    YDFmodels[ModelID] = await YDFInf.loadModelFromZipBlob(byteCharacters);
    console.log(YDFmodels[ModelID]);

    // Concatenated inputs variables :
    concatenatedNames = YDFmodels[ModelID].inputFeatures.map(item => item.name).join(",");
    concatenatedTypes = YDFmodels[ModelID].inputFeatures.map(item => item.type).join(",");
    concatenatedIntenralIdx = YDFmodels[ModelID].inputFeatures.map(item => item.internalIdx).join(",");
    concatenatedSpecIdx = YDFmodels[ModelID].inputFeatures.map(item => item.specIdx).join(",");
    concatenatedLabelClasses = YDFmodels[ModelID].labelClasses.join(",");

    // Return values to BC trigger :
    //event GetModelInputFeatures(Names: Text; Types: Text; InternalIdx: Text; SpecIdx: Text; LabelClasses: Text)
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("LoadModelSuceed",[ModelID, concatenatedNames, concatenatedTypes, concatenatedIntenralIdx, concatenatedSpecIdx, concatenatedLabelClasses],!1);
  }
  catch(err) {
    console.log("YDF sample model loading failed :(");
    console.log(err.message);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("LoadModelFailed",[ModelID, err.message],!1);
  }
}

// Load a model and return informations to BC such as inputs and labels
async function RunModel(ModelID, JsonInputs) {
  try {
    console.log(YDFmodels[ModelID]);

    // Run model using Json inputs:
    console.log(JsonInputs);
    JsonObj = JSON.parse(JsonInputs);
    predictions = YDFmodels[ModelID].predict(JsonObj);
    console.log(predictions);

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("RunModelSuceed", [ModelID, predictions.toString()], !1);
  }
  catch(err) {
    console.log("YDF sample model loading failed :(");
    console.log(err.message);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("RunModelFailed", [ModelID, err.message], !1);
  }
}

// Convert blob variable to base 64 text content
// Without leading description (such as data:application/zip;base64,...)
function blobToBase64(blob) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onloadend = () => {
      const base64String = reader.result.split(',')[1]; // Extract everything after the comma
      resolve(base64String);
    };

    reader.onerror = (error) => {
      reject(error);
    };

    reader.readAsDataURL(blob);
  });
}


function Feature(name, semantic, min_vocab_frequency) {
  this.name = name;
  this.semantic = semantic;
  this.min_vocab_frequency = min_vocab_frequency;
}