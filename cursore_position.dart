String _handleCursorPosition(String symbol) {
    var cursorPos = widget.editingController.selection.base.offset;

    // Right text of cursor position
    String suffixText = widget.editingController.text.substring(cursorPos);

    // Add new text on cursor position
    String specialChars = symbol;
    int length = specialChars.length;

    // Get the left text of cursor
    String prefixText = widget.editingController.text.substring(0, cursorPos);

    String text = prefixText + specialChars + suffixText;

    // Cursor move to end of added text and  update textController value
    widget.editingController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: cursorPos + length,
        extentOffset: cursorPos + length,
      ),
      composing: widget.editingController.value.composing,
    );
    return text;
  }
