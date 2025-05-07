table 61350 "YDF AI Models"
{
    DataClassification = ToBeClassified;
    LookupPageId = "YDF Models";

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(10; Name; Text[150])
        {

        }
        field(20; "Model File"; Blob)
        {

        }
        field(21; "Model Size (Ko)"; Integer)
        {

        }
        field(30; "Map to BC Base Table"; Integer)
        {
            TableRelation = "Table Metadata".ID;
        }
        field(35; "Model Inputs"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("YDF Model Input Features" where("Model ID" = field(ID)));
        }
        field(40; "Model Labels"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("YDF Model Labels" where("Model ID" = field(ID)));
        }
        field(500; "Map Output to BC Field"; Integer)
        {
            TableRelation = Field."No." where(TableNo = field("Map to BC Base Table"));
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        YDFModelInputFeatures: Record "YDF Model Input Features";
        YDFModelLabels: Record "YDF Model Labels";
    begin
        // Delete all input features
        YDFModelInputFeatures.Setrange("Model ID", Rec.ID);
        YDFModelInputFeatures.DeleteAll();
        // Delete all labels
        YDFModelLabels.SetRange("Model ID", Rec.ID);
        YDFModelLabels.DeleteAll();
    end;

    procedure UploadModelFile(Instr: InStream)
    var
        OutStr: OutStream;
    begin
        // Save file in BC
        Rec."Model File".CreateOutStream(Outstr);
        Instr.Position := 1;
        CopyStream(Outstr, Instr);
        Rec."Model Size (Ko)" := round(Instr.Length / 1024, 1);
        Rec.Modify();
    end;

    procedure UpdateModelData(FeaturesNames: Text; FeaturesTypes: Text; FeaturesInternalIdx: Text; FeaturesSpecIdx: Text; LabelClasses: Text)
    var
        ModelLabels: Record "YDF Model Labels";
        ModelInputFeatures: Record "YDF Model Input Features";
        LabelClassesArray: List of [Text];
        NamesArray: List of [Text];
        TypesArray: List of [Text];
        InternalIdxArray: List of [Text];
        SpecIdxArray: List of [Text];
        i: Integer;
    begin
        NamesArray := FeaturesNames.Split(',');
        TypesArray := FeaturesTypes.Split(',');
        InternalIdxArray := FeaturesInternalIdx.Split(',');
        SpecIdxArray := FeaturesSpecIdx.Split(',');

        // Update model input features :
        ModelInputFeatures.SetRange("Model ID", Rec.ID);
        ModelInputFeatures.DeleteAll();
        for i := 1 to NamesArray.Count do begin
            ModelInputFeatures.Init();
            ModelInputFeatures."Model ID" := Rec.ID;
            ModelInputFeatures."Input No." := i;
            ModelInputFeatures."YDF Input Name" := NamesArray.Get(i);
            ModelInputFeatures."YDF Input Type" := TypesArray.Get(i);
            evaluate(ModelInputFeatures."YDF internalidx", InternalIdxArray.Get(i));
            evaluate(ModelInputFeatures."YDF specIdc", SpecIdxArray.Get(i));
            ModelInputFeatures.Insert(true);
        end;

        // Update model output labels, if any :
        ModelLabels.SetRange("Model ID", Rec.ID);
        ModelLabels.DeleteAll();
        if LabelClasses <> '' then begin
            LabelClassesArray := LabelClasses.Split(',');
            for i := 1 to LabelClassesArray.Count do begin
                ModelLabels.Init();
                ModelLabels."Model ID" := Rec.ID;
                ModelLabels."Label No." := i - 1; // Label classes are 0 based
                ModelLabels."Label Text" := LabelClassesArray.Get(i).TrimStart('''').TrimEnd(''''); // remove leading and ending quote
                ModelLabels.Insert(true);
            end;
        end;
    end;

    procedure DecodeOutputBestValue(RawYDFResult: Text; var Confidence: Integer) OutPutResult: Text
    var
        LabelClasses: Record "YDF Model Labels";
        ResultList: List of [Text];
        i: Integer;
        Eval: Decimal;
        MaxVal: Decimal;
        MaxPosition: Integer;
    begin
        // Split JS array result to text list
        ResultList := RawYDFResult.Split(',');
        // Convert each text to decimal to find the best score index
        if ResultList.Count() > 1 then begin
            for i := 1 to ResultList.Count() do begin
                Evaluate(Eval, ResultList.Get(i));
                if Eval > MaxVal then begin
                    MaxVal := Eval;
                    MaxPosition := i;
                end;
            end;
            Confidence := round(MaxVal * 100, 1);
            if LabelClasses.Get(Rec.ID, MaxPosition - 1) then // Position is 1 based for list, but 0 based in model labels
                OutPutResult := LabelClasses."Label Text"
            else
                OutPutResult := RawYDFResult;
        end else
            if LabelClasses.Get(Rec.ID, 0) then begin
                // Single candidate but with label (0 = first label, 1 = second label)
                Evaluate(Eval, RawYDFResult);
                if Eval <= 0.5 then begin
                    OutPutResult := LabelClasses."Label Text";
                    Confidence := round((0.5 - Eval) * 200, 1); // 0.00 = 100% - 0.50 = 0%
                end else begin
                    if LabelClasses.Get(Rec.ID, 1) then;
                    OutPutResult := LabelClasses."Label Text";
                    Confidence := round((Eval - 0.5) * 200, 1); // 0.50 = 0% - 1.0 = 100%
                end;
            end else begin
                // Undefined for single numerical prediction output
                Confidence := 0;
                OutPutResult := RawYDFResult;
            end;

    end;

    procedure GetModelContentAsB64Text() Base64ModelFileContent: Text
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
    begin
        Rec.TestField("Model File");
        Rec.CalcFields("Model File");
        TempBlob.FromRecord(Rec, Rec.FieldNo("Model File"));
        TempBlob.CreateInStream(InStream);
        Base64ModelFileContent := Base64Convert.ToBase64(InStream);
    end;
}