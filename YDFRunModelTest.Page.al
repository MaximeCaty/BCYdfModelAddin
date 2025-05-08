page 61353 "YDF Run Model Test"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "YDF AI Models";
    AboutTitle = 'Run and test YDF Model';
    AboutText = 'This page let you enter input and test the model execution output. The result show the output value with the best score and the confidence percentage.';

    layout
    {
        area(Content)
        {
            group(Model)
            {
                field(ID; Rec.ID)
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field(LoadingStatus; LoadingStatus)
                {
                    Caption = 'Status';
                    Editable = false;
                    StyleExpr = LoadingStyle;
                }
            }
            group(Inputs)
            {
                group(Input1G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 0;
                    field(Input1; Inputs[1])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 1';
                        CaptionClass = InputsCaption[1];
                    }
                }
                group(Input2G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 1;
                    field(Input2; Inputs[2])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 2';
                        CaptionClass = InputsCaption[2];
                    }
                }
                group(Input3G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 2;
                    field(Input3; Inputs[3])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 3';
                        CaptionClass = InputsCaption[3];
                    }
                }
                group(Input4G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 3;
                    field(Input4; Inputs[4])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 4';
                        CaptionClass = InputsCaption[4];
                    }
                }
                group(Input5G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 4;
                    field(Input5; Inputs[5])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 5';
                        CaptionClass = InputsCaption[5];
                    }
                }
                group(Input6G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 5;
                    field(Input6; Inputs[6])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 6';
                        CaptionClass = InputsCaption[6];
                    }
                }
                group(Input7G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 6;
                    field(Input7; Inputs[7])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 7';
                        CaptionClass = InputsCaption[7];
                    }
                }
                group(Input8G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 7;
                    field(Input8; Inputs[8])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 8';
                        CaptionClass = InputsCaption[8];
                    }
                }
                group(Input9G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 8;
                    field(Input9; Inputs[9])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 9';
                        CaptionClass = InputsCaption[9];
                    }
                }
                group(Input10G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 9;
                    field(Input10; Inputs[10])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 10';
                        CaptionClass = InputsCaption[10];
                    }
                }
                group(Input11G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 10;
                    field(Input11; Inputs[11])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 11';
                        CaptionClass = InputsCaption[11];
                    }
                }
                group(Input12G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 11;
                    field(Input12; Inputs[12])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 12';
                        CaptionClass = InputsCaption[12];
                    }
                }
                group(Input13G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 12;
                    field(Input13; Inputs[13])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 13';
                        CaptionClass = InputsCaption[13];
                    }
                }
                group(Input14G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 13;
                    field(Input14; Inputs[14])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 14';
                        CaptionClass = InputsCaption[14];
                    }
                }
                group(Input15G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 14;
                    field(Input15; Inputs[15])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 15';
                        CaptionClass = InputsCaption[15];
                    }
                }
                group(Input16G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 15;
                    field(Input16; Inputs[16])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 16';
                        CaptionClass = InputsCaption[16];
                    }
                }
                group(Input17G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 16;
                    field(Input17; Inputs[17])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 17';
                        CaptionClass = InputsCaption[17];
                    }
                }
                group(Input18G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 17;
                    field(Input18; Inputs[18])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 18';
                        CaptionClass = InputsCaption[18];
                    }
                }
                group(Input19G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 18;
                    field(Input19; Inputs[19])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 19';
                        CaptionClass = InputsCaption[19];
                    }
                }
                group(Input20G)
                {
                    ShowCaption = false;
                    Visible = InputsCount > 19;
                    field(Input20; Inputs[20])
                    {
                        ApplicationArea = All;
                        ToolTip = 'Input 20';
                        CaptionClass = InputsCaption[20];
                    }
                }
            }
            group(Result)
            {
                field(ExecDuration; ExecDuration)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Execution Duration';
                    Caption = 'Execution Duration';
                }
                field(OutPutResult; OutPutResult)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Output Result';
                    Caption = 'Output Result';
                }
                field(OutputConfidence; OutputConfidence)
                {
                    Editable = false;
                    ToolTip = 'The confidence of the best output result found';
                    Caption = 'Output confidence';
                }
            }
            usercontrol(YDFAddin; YDFModelAddin)
            {
                trigger AddinReady()
                begin
                    AddinLoaded := true;

                    // Load AI Model
                    LoadingStatus := 'Loading Model...';
                    Rec.CalcFields("Model File");
                    CurrPage.YDFAddin.LoadModel(Rec.ID, Rec.GetModelContentAsB64Text());
                end;

                trigger LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text)
                begin
                    LoadingStatus := 'Model Loaded - Ready to use';
                    LoadingStyle := 'Favorable';
                    ModelLoaded := true;
                end;

                trigger LoadModelFailed(ModelID: Integer; ErrorMessage: Text)
                begin
                    LoadingStatus := 'Failed to load model';
                    LoadingStyle := 'Unfavorable';
                    ModelLoaded := false;
                end;

                trigger RunModelSuceed(ModelID: Integer; Result: Text)
                var
                    Confidence: Integer;
                begin
                    // Calculate execution duration
                    ExecDuration := CurrentDateTime - StartDateTime;
                    OutPutResult := Rec.DecodeOutputBestValue(Result, Confidence);
                    OutputConfidence := Format(Confidence) + '%';
                end;

                trigger RunModelFailed(ModelID: Integer; ErrorMessage: Text)
                begin
                    Message('Error: %1', ErrorMessage);
                end;

            }
        }
    }

    actions
    {
        area(Prompting)
        {
            action(Run)
            {

                Image = Sparkle;
                ApplicationArea = All;
                ToolTip = 'Run the YDF model using the inputs provided.';
                Caption = 'Run Model';
                Visible = AddinLoaded and (InputsCount > 0);

                trigger OnAction()
                var
                    I: Integer;
                    JsonInputs: Text;
                    WordsList: List of [Text];
                    Word: Text;
                    CRLF: Text;
                    InputLine: Text;
                begin
                    if not ModelLoaded then
                        Error('The model as not been loaded yet.');

                    CRLF[1] := 13;
                    CRLF[2] := 10;

                    // Create Json input
                    for I := 1 to InputsCount do begin
                        if JsonInputs <> '' then
                            JsonInputs += ',';
                        if InputsType[i] = 'CATEGORICAL_SET' then begin
                            // Cleanup text for unsupported char (CRLF , / \ " ; )
                            InputLine += '''' + DELCHR(Format(Inputs[i]), '=', CRLF).Replace(',', ' ').Replace('''', ' ').Replace('\', '').Replace('/', '').Replace('"', ' ').Replace(';', '').Trim() + ''',';
                            WordsList := InputLine.Trim().Split(' ');
                            JsonInputs += '"' + InputsCaption[I] + '": [[';
                            foreach Word in WordsList do
                                JsonInputs += '"' + Word + '",';
                            JsonInputs := JsonInputs.TrimEnd(',') + ']]';
                        end else
                            JsonInputs += '"' + InputsCaption[I] + '": ["''' + Inputs[I] + '''"]'
                    end;
                    JsonInputs := '{' + JsonInputs + '}';

                    // Run the model
                    StartDateTime := CurrentDateTime;
                    CurrPage.YDFAddin.RunModel(Rec.ID, JsonInputs);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        YDFModelInput: Record "YDF Model Input Features";
        YDFModelLabel: Record "YDF Model Labels";
    begin
        // Clear vars
        Rec.TestField("Model File");
        InputsCount := 0;
        ExecDuration := 0;
        Clear(OutputLabels);
        Clear(InputsCaption);
        Clear(InputsType);
        OutPutResult := '';

        // Load inputs
        YDFModelInput.SetRange("Model ID", Rec."ID");
        YDFModelInput.FindSet();
        repeat
            InputsCount += 1;
            InputsCaption[InputsCount] := YDFModelInput."YDF Input Name";
            InputsType[InputsCount] := YDFModelInput."YDF Input Type";
        until YDFModelInput.Next() = 0;

        // Load labels if any
        YDFModelLabel.SetRange("Model ID", Rec."ID");
        if YDFModelLabel.FindSet() then
            repeat
                OutputLabels.Add(YDFModelLabel."Label Text");
            until YDFModelLabel.Next() = 0;
    end;

    trigger OnOpenPage()
    begin
        LoadingStatus := 'Initalize Addin...';
        LoadingStyle := 'StrongAccent';
    end;

    var
        InputsCount: Integer;
        Inputs: array[99] of Text;
        InputsCaption: array[99] of Text;
        InputsType: array[99] of Text;

        OutPutResult: Text;
        OutputConfidence: Text;
        OutputLabels: List of [Text];
        ExecDuration: Duration;
        StartDateTime: DateTime;
        AddinLoaded: Boolean;
        ModelLoaded: Boolean;
        LoadingStatus: Text;
        LoadingStyle: Text;
}