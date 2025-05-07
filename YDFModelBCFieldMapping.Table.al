table 61353 "YDF Model BC Field Mapping"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Model ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Line No."; Integer)
        {

        }
        field(100; "Base Table No."; Integer)
        {

        }
        field(110; "Base Table Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Table Metadata".Name where(ID = field("Base Table No.")));
            Editable = false;
        }
        field(120; "Base Field No."; Integer)
        {
            TableRelation = Field."No." where(TableNo = field("Base Table No."));
        }
        field(130; "Base Field Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Base Table No."), "No." = field("Base Field No.")));
            Editable = false;
        }
        field(150; "Is Output"; Boolean)
        {
            trigger OnValidate()
            var
                ModelBCFieldMapping: Record "YDF Model BC Field Mapping";
            begin
                ModelBCFieldMapping.SetRange("Model ID", Rec."Model ID");
                ModelBCFieldMapping.SetFilter("Base Field No.", '<>%1', Rec."Base Field No.");
                ModelBCFieldMapping.ModifyAll("Is Output", false);
            end;
        }
    }

    keys
    {
        key(Key1; "Model ID", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Model: Record "YDF AI Models";
    begin
        Model.SetLoadFields("Map to BC Base Table");
        Model.Get(Rec."Model ID");
        "Base Table No." := Model."Map to BC Base Table";
    end;
}