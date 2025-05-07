page 61351 "YDF Models Inputs List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "YDF Model Input Features";
    UsageCategory = Lists;
    AboutTitle = 'AI Model Input Features';
    AboutText = 'This page show the list input required for the model to run. The model use thoses input to make prediction. Internally, the model only use numerical data, text inputs are converted using internal dicitonnary, splitted by words (space). Dictionnary is built during the model training, unknown word in input are not used by the model.';

    layout
    {
        area(Content)
        {
            repeater(Lst)
            {
                field(No; Rec."Input No.")
                {
                    ApplicationArea = All;
                }
                field(Nm; Rec."YDF Input Name")
                {
                    ApplicationArea = All;
                }
                field(Tp; Rec."YDF Input Type")
                {
                    ApplicationArea = All;
                }
                field(Idx; Rec."YDF internalidx")
                {
                    ApplicationArea = All;
                }
                field(SpecIdx; Rec."YDF specIdc")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}