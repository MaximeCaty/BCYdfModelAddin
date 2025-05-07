page 61352 "YDF Model Label List"
{
    Caption = 'YDF Model Label List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "YDF Model Labels";
    InsertAllowed = false;
    DeleteAllowed = false;
    AboutTitle = 'AI Model Label classes';
    AboutText = 'This page show the list of text label the library as detected regarding output possibilities. Internally, the model only use numerical data to train and run : label classes are used to map the model output to a text value.';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Label No."; Rec."Label No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Label Text"; Rec."Label Text")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}