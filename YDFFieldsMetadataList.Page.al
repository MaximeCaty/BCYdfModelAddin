page 61355 "YDF Fields Metadata List"
{
    ApplicationArea = All;
    Caption = 'Fields Metadata List', Comment = 'Liste métadata champs';
    Editable = false;
    PageType = List;
    SourceTable = Field;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(fieldsRpt)
            {
                field(IsPartOfPrimaryKey; Rec.IsPartOfPrimaryKey) { }
                field("No."; Rec."No.") { }
                field(FieldName; Rec.FieldName) { }
                field("Field Caption"; Rec."Field Caption") { }
                field(Class; Rec.Class) { }
                field(Type; Rec.Type) { }
                field("Type Name"; Rec."Type Name") { }
                field(Len; Rec.Len) { }
                field(SQLDataType; Rec.SQLDataType) { }
                field(OptionString; Rec.OptionString) { }
            }
        }
    }

    procedure GetSelectedFields(var FieldRec: Record Field)
    begin
        CurrPage.SetSelectionFilter(FieldRec);
        FieldRec.FindFirst();
    end;
}