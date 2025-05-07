table 61351 "YDF Model Input Features"
{
    DataClassification = ToBeClassified;
    LookupPageId = "YDF Models Inputs List";
    DrillDownPageId = "YDF Models Inputs List";

    fields
    {
        field(1; "Model ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "YDF AI Models".ID;
        }
        field(10; "Input No."; Integer)
        {
            autoIncrement = true;
        }
        field(20; "YDF Input Name"; Text[150])
        {
            Editable = false;
        }
        field(30; "YDF Input Type"; Text[100])
        {
            Editable = false;
        }
        field(40; "YDF internalidx"; integer)
        {
            Editable = false;
        }
        field(50; "YDF specIdc"; Integer)
        {
            Editable = false;
        }
        field(500; "Map To BC Table No."; Integer)
        {
            TableRelation = "Table Metadata".ID;
        }
        field(501; "Map To BC Field No."; Integer)
        {
            TableRelation = Field."No." where(TableNo = field("Map To BC Table No."));
        }

    }

    keys
    {
        key(Key1; "Model ID", "Input No.")
        {
            Clustered = true;
        }
    }

}