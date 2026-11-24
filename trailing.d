module matn.editor.trailing;

import matn.ui.grid.cell : Color, CellStyle;
import matn.extension.base;

/// Trailing Whitespace Highlighter & Trimmer Extension
class TrailingWhitespaceExtension : Extension
{
    private Color _highlightBg = Color(140, 45, 55, 200);

    this()
    {
        super(ExtensionManifest(
            "matn.trailing",
            "Trailing Whitespace",
            "1.0.0",
            "Matn Core",
            "Highlights trailing spaces/tabs and supports one-click buffer trimming",
            true
        ));
        this._enabled = true;
    }

    override protected void onActivate()
    {
        if (_context)
        {
            _context.registerSetting("EDITOR", "Trailing Whitespace", "Highlight extraneous trailing spaces", {
                _enabled = !_enabled;
            });
        }
    }

    @property Color highlightBg() const { return _highlightBg; }

    /// Returns index where trailing whitespace begins on line, or -1 if no trailing whitespace
    int getTrailingWhitespaceStart(const(dchar)[] line) const
    {
        if (!_enabled || line.length == 0) return -1;

        int lastNonSpace = -1;
        foreach_reverse (i, c; line)
        {
            if (c != ' ' && c != '\t' && c != '\r')
            {
                lastNonSpace = cast(int) i;
                break;
            }
        }

        if (lastNonSpace == -1)
        {
            // Entire line is whitespace
            return 0;
        }
        else if (lastNonSpace + 1 < line.length)
        {
            return lastNonSpace + 1;
        }

        return -1;
    }
}
