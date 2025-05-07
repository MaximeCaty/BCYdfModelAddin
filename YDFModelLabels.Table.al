table 61352 "YDF Model Labels"
{
    DataClassification = ToBeClassified;
    LookupPageId = "YDF Model Label List";
    DrillDownPageId = "YDF Model Label List";

    fields
    {
        field(1; "Model ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "YDF AI Models".ID;
        }
        field(10; "Label No."; Integer)
        {

        }
        field(20; "Label Text"; Text[250])
        {

        }
    }

    keys
    {
        key(Key1; "Model ID", "Label No.")
        {
            Clustered = true;
        }
    }

}