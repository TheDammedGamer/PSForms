class PSFormsParagraph {
    # Property: Holds the text to display
    [String] $Text

    PSFormsParagraph([string]$InputText) {
        $this.Text = $InputText
    }

    [string]ConvertToHTML() {
        $HTML = Div -Class "form-group" -Content {
            p -Class "form-text" -Content - $this.Text
        }
        return $HTML
    }
}