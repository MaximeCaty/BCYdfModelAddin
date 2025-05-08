page 61354 "YDF Model BC Field Mapping"
{
    Caption = 'YDF Model BC Field Mapping';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "YDF Model BC Field Mapping";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Base Table Name"; Rec."Base Table Name")
                {
                    ApplicationArea = All;
                }
                field("Base Field No."; Rec."Base Field No.")
                {
                    ApplicationArea = All;
                    Lookup = false;

                    trigger OnDrillDown()
                    var
                        Model: Record "YDF AI Models";
                        FieldRec: Record Field;
                        FieldsList: Page "YDF Fields Metadata List";
                    begin
                        Model.Get(Rec."Model ID");
                        FieldRec.SetRange(TableNo, Model."Map to BC Base Table");
                        FieldRec.SetRange(Enabled, true);
                        FieldRec.SetFilter("No.", '<2000000000');
                        FieldsList.SetTableView(FieldRec);
                        FieldsList.LookupMode(true);
                        if (FieldsList.RunModal() in [Action::LookupOK, Action::OK, Action::Yes])
                        and CurrPage.Editable then begin
                            FieldsList.GetSelectedFields(FieldRec);
                            Rec.Validate("Base Field No.", FieldRec."No.");
                            Rec.CalcFields("Base Field Name");
                        end;
                    end;
                }
                field("Base Field Name"; Rec."Base Field Name")
                {
                    ApplicationArea = All;
                }
                field("Is Output"; Rec."Is Output")
                {
                    ApplicationArea = All;
                }

            }
            usercontrol(YDFAddin; YDFModelAddin)
            {
                trigger AddinReady()
                begin
                    AddinLoaded := true;
                end;

                trigger TrainModelSuceed(Base64ModelFileContent: Text)
                var
                    Model: Record "YDF AI Models";
                    TempBlob: Codeunit "Temp Blob";
                    Base64: Codeunit "Base64 Convert";
                    InStream: InStream;
                    OutStream: OutStream;
                    file: Text;
                    Base64Result: Text;
                    Base64Convert: Codeunit "Base64 Convert";
                begin
                    TempBLOB.CreateOutStream(OutStream);
                    Base64.FromBase64(Base64ModelFileContent, OutStream);
                    TempBLOB.CreateInStream(InStream);
                    file := 'trained-model.ydf.zip';
                    DownloadFromStream(
                        InStream,  // InStream to save
                        '',   // Not used in cloud
                        '',   // Not used in cloud
                        '',   // Not used in cloud
                        file); // Filename is browser download folder
                    if confirm('The model has been created sucessfully and downloaded. Would you like to upload it in Business Central ?') then begin
                        Model.Get(Rec."Model ID");
                        // Load model in JS (to update inputs and labels)
                        Base64Result := Base64Convert.ToBase64(InStream);
                        CurrPage.YDFAddin.LoadModel(Model.ID, Base64Result);
                        // Save file in BC
                        Model.UploadModelFile(InStream);
                    end;
                end;

                trigger LoadModelSuceed(ModelID: Integer; FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text)
                var
                    Model: Record "YDF AI Models";
                begin
                    Model.Get(ModelID);
                    Model.UpdateModelData(FeaturesNames, FeaturesTypes, FeaturesInternalIdx, FeaturesSpecIdx, LabelClasses);
                    Message('Model has been loaded, inputs and labels were updated sucessfully.');
                end;

                trigger TrainModelFailed(ErrorMessage: Text)
                begin
                    Message('Unable to train the model. Javascript error : ', ErrorMessage);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TrainModel)
            {
                ApplicationArea = All;
                Image = Process;
                Caption = 'Train Model';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    FieldRef: FieldRef;
                    Model: Record "YDF AI Models";
                    ModelFieldMapping: Record "YDF Model BC Field Mapping";
                    RecRef: RecordRef;
                    Win: Dialog;
                    InputData: Text;
                    InputLine: Text;
                    CRLF: Text;
                    OutputFieldName: Text[30];
                    I: Integer;
                    Count: Integer;
                begin
                    if not AddinLoaded then
                        Error('The library is not loaded yet.');
                    CRLF[1] := 13;
                    CRLF[2] := 10;
                    Win.Open('Loading Dataset from busienss central...');
                    Model.Get(Rec."Model ID");
                    Model.TestField("Map to BC Base Table");
                    RecRef.Open(Model."Map to BC Base Table");

                    // Fill header (fields names)
                    ModelFieldMapping.SetRange("Model ID", Model.ID);
                    ModelFieldMapping.SetAutoCalcFields("Base Field Name");
                    ModelFieldMapping.FindSet();
                    repeat
                        InputData += ModelFieldMapping."Base Field Name" + ',';
                        if ModelFieldMapping."Is Output" then
                            OutputFieldName := ModelFieldMapping."Base Field Name";
                        RecRef.AddLoadFields(ModelFieldMapping."Base Field No."); // only select the field we need to improve performance
                    until ModelFieldMapping.Next() = 0;
                    InputData := InputData.TrimEnd(',');
                    if OutputFieldName = '' then
                        Error('There must be at one Output field.');

                    // Fill datas
                    Count := Recref.Count(); // for UI progression
                    if not Confirm(StrSubstNo('Business Central table contain %1 records. The training may take longer depending on the number of records to evaluate and the web page may freeze. Continue ?', Count)) then
                        exit;

                    RecRef.FindSet();
                    Win.Close();
                    Win.Open('Preparing training dataset... \ #1############');
                    repeat
                        InputLine := '';
                        ModelFieldMapping.FindSet();
                        repeat
                            case RecRef.Field(ModelFieldMapping."Base Field No.").Type of
                                FieldRef.Type::Integer,
                                FieldRef.Type::Decimal:
                                    InputLine += Format(RecRef.Field(ModelFieldMapping."Base Field No.").Value) + ','
                                else
                                    // Cleanup text for unsupported char (CRLF , / \ " ; )
                                    InputLine += '''' + DELCHR(Format(RecRef.Field(ModelFieldMapping."Base Field No.").Value), '=', CRLF).Replace(',', ' ').Replace('''', ' ').Replace('\', '').Replace('/', '').Replace('"', ' ').Replace(';', '').Trim() + ''',';
                            end;
                            if I mod 10 = 0 then
                                Win.Update(1, ProgressBar(I / Count));
                        until ModelFieldMapping.Next() = 0;
                        InputLine := InputLine.TrimEnd(',');
                        if (InputLine <> '') and (InputLine <> '," "') then
                            InputData += CRLF + InputLine;
                        I += 1;
                    until RecRef.Next() = 0;
                    Win.Close();
                    Message('The model is now trainning in the background on your browser. Once the process is completed the file will be downloaded.');
                    CurrPage.YDFAddin.TrainModel(InputData, OutputFieldName);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Model: Record "YDF AI Models";
        YDFBCMapping: Record "YDF Model BC Field Mapping";
    begin
        Model.Get(Rec."Model ID");
        Rec."Base Table No." := Model."Map to BC Base Table";
        Rec.CalcFields("Base Table Name");
        Rec."Line No." := 10000;
        YDFBCMapping.SetRange("Model ID", Rec."Model ID");
        if YDFBCMapping.FindLast() then
            Rec."Line No." := YDFBCMapping."Line No." + 10000;
    end;

    trigger OnOpenPage()
    var
        Model: Record "YDF AI Models";
    begin
        Model.Get(Rec."Model ID");
        Model.TestField("Map to BC Base Table");
    end;

    procedure ProgressBar(ProgressPercent: Decimal) AsciiResult: Text
    var
        i: Integer;
        ProgressChar: Integer;
    begin
        ProgressChar := Round(ProgressPercent * 24, 1, '<') + 1;
        for i := 1 to 24 do begin
            if i < ProgressChar then
                AsciiResult += '▓'
            else
                AsciiResult += '░';
            if i = 12 then // half of 25
                AsciiResult += Format(Round(ProgressPercent * 100, 1)).PadLeft(2, '0') + '%';
        end;
    end;

    var
        AddinLoaded: Boolean;
}