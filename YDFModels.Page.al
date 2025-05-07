page 61350 "YDF Models"
{
    Caption = 'YDF AI Models List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "YDF AI Models";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Lst)
            {
                field(ID; Rec.ID)
                {

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the model.';
                }
                field("Model Size"; Rec."Model Size (Ko)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the model.';
                    Editable = false;
                }
                field("Input Table"; Rec."Map to BC Base Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table used for input field mapping and training.';
                }
                field("Model Inputs"; Rec."Model Inputs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of inputs of the model.';
                }
                field("Model Labels"; Rec."Model Labels")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of output labels classes of the model.';
                }
                field("Map Output to BC Field"; Rec."Map Output to BC Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Business central field to map the model output to.';
                }
            }
            usercontrol(YDFAddin; YDFModelAddin)
            {
                trigger AddinReady()
                begin
                    AddinLoaded := true;
                end;

                trigger TestSuceed(Base64ModelFileContent: Text)
                var
                    TempBlob: Codeunit "Temp Blob";
                    Base64: Codeunit "Base64 Convert";
                    InStream: InStream;
                    OutStream: OutStream;
                    file: Text;
                begin
                    Message('The test completed sucessfully. Demo trained model file will be downloaded. Ppen browser console to see technical details of the test');

                    TempBLOB.CreateOutStream(OutStream);
                    Base64.FromBase64(Base64ModelFileContent, OutStream);
                    TempBLOB.CreateInStream(InStream);
                    file := 'demo-model.ydf.zip';
                    DownloadFromStream(
                        InStream,  // InStream to save
                        '',   // Not used in cloud
                        '',   // Not used in cloud
                        '',   // Not used in cloud
                        file); // Filename is browser download folder
                end;

                trigger TestFailed(ErrorMessage: Text)
                begin
                    Error('The test failed. Javascript error :\%1 \Open browser console for more details.', ErrorMessage);
                end;

                trigger LoadModelFailed(ModelID: Integer; ErrorMessage: Text)
                begin
                    Error('The model file could not be loaded. Javascript error :\%1', ErrorMessage);
                end;

                trigger LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text)
                begin
                    Rec.UpdateModelData(FeaturesNames, FeaturesTypes, FeaturesInternalIdx, FeaturesSpecIdx, LabelClasses);
                    Message('Model has been loaded, inputs and labels were updated sucessfully.');
                end;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Inputs)
            {
                ApplicationArea = All;
                Caption = 'Model Inputs';
                Image = VariableList;
                RunObject = Page "YDF Models Inputs List";
                RunPageLink = "Model ID" = field(ID);
            }
            action(Labels)
            {
                ApplicationArea = All;
                Caption = 'Model Labels';
                Image = Description;
                RunObject = Page "YDF Model Label List";
                RunPageLink = "Model ID" = field(ID);
            }
        }
        area(Processing)
        {
            action(Verify)
            {
                ApplicationArea = All;
                Caption = 'Verify Model';
                Image = PreviewChecks;
                ToolTip = 'Load the model in YDF library and update model as input features and labels.';

                trigger OnAction()
                begin
                    if not AddinLoaded then
                        Error('The YDF library is not loaded yet.');

                    Rec.TestField("Model File");
                    CurrPage.YDFAddin.LoadModel(Rec.ID, Rec.GetModelContentAsB64Text());
                end;
            }
            action(TestYDF)
            {
                ApplicationArea = All;
                Caption = 'Test YDF Library';
                Image = TestReport;
                ToolTip = 'Test YDF library using google data sample. Result are shown in browser console.';

                trigger OnAction()
                var
                    Win: Dialog;
                begin
                    if not AddinLoaded then
                        Error('The YDF library is not loaded yet.');

                    if confirm('The test will create and train a model based on 2.5 Mb data sample, run the model once, and then download the model zip file. The process may take few seconds. An other message will inform about the completion.') then begin
                        Win.Open('Running AI model demo...');
                        CurrPage.YDFAddin.TestSampleModel();
                        Win.Close();
                    end;
                end;
            }
            action(Download)
            {
                ApplicationArea = All;
                Caption = 'Download Model';
                Image = Download;
                ToolTip = 'Download the selected model.';

                trigger OnAction()
                var
                    Instr: InStream;
                    FileName: Text;
                begin
                    // Has data
                    Rec.CalcFields("Model File");
                    if not (Rec."Model File".HasValue) then
                        Rec.TestField("Model File");

                    // Read file content
                    Rec."Model File".CreateInStream(Instr);

                    FileName := Rec.Name + '.ydf.zip';
                    DownloadFromStream(Instr, '', '', '', FileName);
                end;
            }
            action(Upload)
            {
                ApplicationArea = All;
                Caption = 'Upload Model';
                Image = UpdateXML;
                ToolTip = 'Upload an AI model file that manualy. The model must be Tensorflow SavecModel format (zip file including .pb without json).';

                trigger OnAction()
                var
                    Instr: InStream;
                    FileName: Text;
                    SucessLbl: Label 'The file has been sucessfully uploaded.';
                    Base64Convert: Codeunit "Base64 Convert";
                    Base64Result: Text;
                begin
                    // Upload file
                    UploadIntoStream('', '', 'Zip files (*.zip)|*.zip', FileName, Instr);
                    if (FileName <> '') and (Instr.Length > 0) then begin
                        // Load model in JS (to update inputs and labels)
                        Base64Result := Base64Convert.ToBase64(Instr);
                        CurrPage.YDFAddin.LoadModel(Rec.ID, Base64Result);
                        // Save file in BC
                        Rec.UploadModelFile(Instr);
                        Message(SucessLbl);
                    end;
                end;
            }
        }
        area(Creation)
        {
            action(BCMapping)
            {
                ApplicationArea = All;
                Caption = 'Field Mapping & Training';
                Image = SparkleFilled;
                RunObject = Page "YDF Model BC Field Mapping";
                RunPageLink = "Model ID" = field(ID);

            }
            action(Run)
            {
                ApplicationArea = All;
                Caption = 'Run model';
                Image = Sparkle;
                RunObject = Page "YDF Run Model Test";
                RunPageLink = ID = field(ID);
            }
        }

        area(Promoted)
        {
            actionref(FieldMapTrain; BCMapping) { }
            actionref(RunModel; Run) { }
        }
    }

    var
        AddinLoaded: Boolean;
}